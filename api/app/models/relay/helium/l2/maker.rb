# typed: strict

module Relay
  module Helium
    module L2
      class Maker < ApplicationRecord
        self.table_name = "helium_l2_makers"

        has_many :hotspots, inverse_of: :maker
      end
    end
  end
end
