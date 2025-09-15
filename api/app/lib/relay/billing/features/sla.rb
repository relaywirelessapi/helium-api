# typed: strict

module Relay
  module Billing
    module Features
      class Sla < Feature
        extend T::Sig

        sig { override.returns(String) }
        def name
          "SLA"
        end

        sig { override.returns(String) }
        def description
          "Service Level Agreement with guaranteed uptime and response times"
        end
      end
    end
  end
end
