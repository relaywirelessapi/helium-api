# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class ServiceProviderPromotionType < Relay::Types::BaseObject
          extend T::Sig

          field :service_provider, String, null: false, description: "The service provider."
          field :incentive_escrow_fund_bps, GraphQL::Types::BigInt, null: false, description: "The incentive escrow fund basis points."
          field :promotions, [ PromotionType ], null: false, description: "The promotions."
        end
      end
    end
  end
end
