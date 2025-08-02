# typed: false

module Relay
  module Billing
    module Features
      class CustomerService < Feature
        extend T::Sig

        sig { returns(Symbol) }
        attr_reader :tier

        sig { params(tier: Symbol).void }
        def initialize(tier:)
          @tier = tier
        end

        sig { override.returns(String) }
        def name
          case tier
          when :community
            "Community support"
          when :business
            "Standard support"
          end
        end

        sig { override.returns(String) }
        def description
          case tier
          when :community
            "Community-based support in our Discord."
          when :business
            "Direct support from Relay team."
          end
        end
      end
    end
  end
end
