# typed: strict
# frozen_string_literal: true

module Types
  class MobileRewardDataType < Types::BaseObject
    extend T::Sig

    field :reward_type, String, null: false, description: "The type of reward (mobile)."
    field :poc_bones_per_reward_share, GraphQL::Types::BigInt, null: false, description: "The POC bones per reward share."
    field :boosted_poc_bones_per_reward_share, GraphQL::Types::BigInt, null: false, description: "The boosted POC bones per reward share."
    field :service_provider_promotions, [ Types::ServiceProviderPromotionType ], null: false, description: "The service provider promotions."
    field :token, String, null: false, description: "The token."
  end
end
