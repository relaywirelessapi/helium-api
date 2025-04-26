# typed: false

module Relay
  module Helium
    module L2
      module OracleData
        extend ActiveSupport::Concern

        included do
          belongs_to(
            :file,
            class_name: "Relay::Helium::L2::File",
            foreign_key: [ :file_category, :file_name ],
          )
        end
      end
    end
  end
end
