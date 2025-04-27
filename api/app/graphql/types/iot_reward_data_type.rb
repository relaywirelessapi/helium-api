# typed: strict
# frozen_string_literal: true

module Types
  class IotRewardDataType < Types::BaseObject
    extend T::Sig

    field :reward_type, String, null: false, description: "The type of reward (iot)."
    field :poc_bones_per_beacon_reward_share, GraphQL::Types::BigInt, null: false, description: "The POC bones per beacon reward share."
    field :poc_bones_per_witness_reward_share, GraphQL::Types::BigInt, null: false, description: "The POC bones per witness reward share."
    field :dc_bones_per_share, GraphQL::Types::BigInt, null: false, description: "The DC bones per share."
    field :token, String, null: false, description: "The token."
  end
end
