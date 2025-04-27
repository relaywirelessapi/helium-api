# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class RewardManifestDataType < Relay::Types::BaseUnion
          class RewardManifestIotDataType < Relay::Types::BaseObject
            extend T::Sig

            field :reward_type, String, null: false, description: "The type of reward (iot)."
            field :poc_bones_per_beacon_reward_share, GraphQL::Types::BigInt, null: false, description: "The POC bones per beacon reward share."
            field :poc_bones_per_witness_reward_share, GraphQL::Types::BigInt, null: false, description: "The POC bones per witness reward share."
            field :dc_bones_per_share, GraphQL::Types::BigInt, null: false, description: "The DC bones per share."
            field :token, String, null: false, description: "The token."
          end

          class RewardManifestMobileDataType < Relay::Types::BaseObject
            extend T::Sig

            field :reward_type, String, null: false, description: "The type of reward (mobile)."
            field :poc_bones_per_reward_share, GraphQL::Types::BigInt, null: false, description: "The POC bones per reward share."
            field :boosted_poc_bones_per_reward_share, GraphQL::Types::BigInt, null: false, description: "The boosted POC bones per reward share."
            field :service_provider_promotions, [ ServiceProviderPromotionType ], null: false, description: "The service provider promotions."
            field :token, String, null: false, description: "The token."
          end

          description "Represents either mobile or IoT reward data"
          possible_types RewardManifestMobileDataType, RewardManifestIotDataType

          class << self
            extend T::Sig

            sig do
              params(
                object: T::Hash[String, T.untyped],
                context: GraphQL::Query::Context
              ).returns(T.any(
                T.class_of(RewardManifestMobileDataType),
                T.class_of(RewardManifestIotDataType)
              ))
            end
            def resolve_type(object, context)
              case object["reward_type"]
              when "mobile"
                RewardManifestMobileDataType
              when "iot"
                RewardManifestIotDataType
              else
                raise "Unexpected reward type: #{object["reward_type"].inspect}"
              end
            end
          end
        end
      end
    end
  end
end
