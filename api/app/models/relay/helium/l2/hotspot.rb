# typed: strict

module Relay
  module Helium
    module L2
      class Hotspot < ApplicationRecord
        extend T::Sig

        DEVICE_TYPES = %w[cbrs wifi_indoor wifi_outdoor wifi_data_only]
        NETWORKS = %w[iot mobile]

        self.table_name = "helium_l2_hotspots"

        belongs_to :maker, inverse_of: :hotspots
        has_many :radios, class_name: "Relay::Helium::L2::HotspotRadio", inverse_of: :hotspot

        validates :networks, inclusion: { in: NETWORKS }

        scope :by_networks, ->(networks) { where("networks && ARRAY[?]::varchar[]", networks) }
        scope :by_iot_location, ->(cell) { by_h3_cell(:iot_location, cell) }
        scope :by_mobile_location, ->(cell) { by_h3_cell(:mobile_location, cell) }

        class << self
          extend T::Sig

          sig { params(column: Symbol, cell: Integer).returns(ActiveRecord::Relation) }
          def by_h3_cell(column, cell)
            resolution = H3.resolution(cell)

            if resolution <= 12
              quoted_column = connection.quote_column_name(column)
              where("h3_cell_to_parent(#{quoted_column}::h3index, ?) = (?::h3index)", resolution, cell)
            else
              res_12_parent = H3.parent(cell, 12)
              where(column => res_12_parent)
            end
          end
        end
      end
    end
  end
end
