# typed: strict

module Relay
  module Billing
    module Features
      class HotspotData < Feature
        extend T::Sig

        sig { override.returns(String) }
        def name
          "Hotspot data"
        end

        sig { override.returns(String) }
        def description
          "Access to all Helium NFT information"
        end
      end
    end
  end
end
