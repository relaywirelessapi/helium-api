# typed: strict
# frozen_string_literal: true

module Types
  class ServiceProviderPromotionType < Types::BaseObject
    extend T::Sig

    field :service_provider, String, null: false, description: "The service provider."
    field :incentive_escrow_fund_bps, GraphQL::Types::BigInt, null: false, description: "The incentive escrow fund basis points."
    field :promotions, [ Types::PromotionType ], null: false, description: "The promotions."
  end
end
