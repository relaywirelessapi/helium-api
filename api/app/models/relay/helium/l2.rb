# typed: strict

module Relay
  module Helium
    module L2
      class << self
        extend T::Sig

        sig { returns(String) }
        def table_name_prefix
          "relay_helium_l2_"
        end
      end
    end
  end
end
