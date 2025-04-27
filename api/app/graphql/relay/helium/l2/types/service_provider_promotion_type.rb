# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class ServiceProviderPromotionType < Relay::Types::BaseObject
          extend T::Sig

          class ServiceProviderPromotionDetailType < Relay::Types::BaseObject
            extend T::Sig

            field :entity, String, null: false, description: "The entity."
            field :start_ts, GraphQL::Types::ISO8601DateTime, null: false, description: "The start timestamp."
            field :end_ts, GraphQL::Types::ISO8601DateTime, null: false, description: "The end timestamp."
            field :shares, GraphQL::Types::BigInt, null: false, description: "The shares."
          end

          field :service_provider, String, null: false, description: "The service provider."
          field :incentive_escrow_fund_bps, GraphQL::Types::BigInt, null: false, description: "The incentive escrow fund basis points."
          field :promotions, [ ServiceProviderPromotionDetailType ], null: false, description: "Details of the promotions."
        end
      end
    end
  end
end
