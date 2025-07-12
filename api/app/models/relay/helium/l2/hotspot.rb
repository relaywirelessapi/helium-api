# typed: strict

module Relay
  module Helium
    module L2
      class Hotspot < ApplicationRecord
        DEVICE_TYPES = %w[cbrs wifi_indoor wifi_outdoor wifi_data_only]
        NETWORKS = %w[iot mobile]

        self.table_name = "helium_l2_hotspots"

        belongs_to :maker, inverse_of: :hotspots
        has_many :radios, inverse_of: :hotspot

        validates :device_type, inclusion: { in: DEVICE_TYPES }
        validates :networks, inclusion: { in: NETWORKS }
      end
    end
  end
end
