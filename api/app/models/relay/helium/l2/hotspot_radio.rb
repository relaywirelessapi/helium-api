# typed: strict

module Relay
  module Helium
    module L2
      class HotspotRadio < ApplicationRecord
        self.table_name = "helium_l2_hotspot_radios"

        belongs_to :hotspot, inverse_of: :radios
      end
    end
  end
end
