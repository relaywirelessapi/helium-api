# typed: strict

module Relay
  module Billing
    module Features
      class CustomerService < Feature
        class Tier
          extend T::Sig

          class << self
            extend T::Sig

            sig { returns(Tier) }
            def community
              new(name: "Community support", description: "Community-based support in our Discord")
            end

            sig { returns(Tier) }
            def business
              new(name: "Customer Support", description: "Direct support from the Relay team")
            end

            sig { returns(Tier) }
            def enterprise
              new(name: "Customer Support + SLA", description: "Direct support from the Relay team with Service Level Agreement")
            end
          end

          sig { returns(String) }
          attr_reader :name

          sig { returns(String) }
          attr_reader :description

          sig { params(name: String, description: String).void }
          def initialize(name:, description:)
            @name = name
            @description = description
          end
        end

        extend T::Sig

        sig { returns(Tier) }
        attr_reader :tier

        sig { params(tier: Tier).void }
        def initialize(tier:)
          @tier = tier
        end

        sig { override.returns(String) }
        def name
          tier.name
        end

        sig { override.returns(String) }
        def description
          tier.description
        end
      end
    end
  end
end
