# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class MobileRewardShareType < Relay::Types::BaseObject
          extend T::Sig

          class MobileRadioRewardDetailType < Relay::Types::BaseObject
            description "Represents a mobile radio reward share."

            field :hotspot_key, String, null: true, description: "The key of the hotspot."
            field :cbsd_id, String, null: true, description: "The CBSD ID."
            field :dc_transfer_reward, GraphQL::Types::BigInt, null: true, description: "The amount of DC transfer rewards."
            field :poc_reward, GraphQL::Types::BigInt, null: true, description: "The amount of POC rewards."
          end

          class MobileGatewayRewardDetailType < Relay::Types::BaseObject
            description "Represents a mobile gateway reward share."

            field :hotspot_key, String, null: true, description: "The key of the hotspot."
            field :dc_transfer_reward, GraphQL::Types::BigInt, null: true, description: "The amount of DC transfer rewards."
          end

          class MobileSubscriberRewardDetailType < Relay::Types::BaseObject
            description "Represents a mobile subscriber reward share."

            field :subscriber_id, String, null: true, description: "The subscriber ID."
            field :discovery_location_amount, GraphQL::Types::BigInt, null: true, description: "The amount of discovery location rewards."
          end

          class MobileServiceProviderRewardDetailType < Relay::Types::BaseObject
            description "Represents a mobile service provider reward share."

            field :service_provider_id, String, null: true, description: "The service provider ID."
            field :amount, GraphQL::Types::BigInt, null: true, description: "The service provider amount."
          end

          class MobileUnallocatedRewardDetailType < Relay::Types::BaseObject
            description "Represents a mobile unallocated reward share."

            field :unallocated_reward_type, String, null: true, description: "The type of unallocated reward."
            field :amount, GraphQL::Types::BigInt, null: true, description: "The amount of the reward."
          end

          class MobileRadioRewardV2ShareType < Relay::Types::BaseObject
            description "Represents a mobile radio reward v2 share."

            field :hotspot_key, String, null: true, description: "The key of the hotspot."
            field :cbsd_id, String, null: true, description: "The CBSD ID."
            field :base_coverage_points_sum, GraphQL::Types::Float, null: true, description: "The sum of base coverage points."
            field :boosted_coverage_points_sum, GraphQL::Types::Float, null: true, description: "The sum of boosted coverage points."
            field :base_reward_shares, GraphQL::Types::Float, null: true, description: "The base reward shares."
            field :boosted_reward_shares, GraphQL::Types::Float, null: true, description: "The boosted reward shares."
            field :base_poc_reward, GraphQL::Types::BigInt, null: true, description: "The base POC reward."
            field :boosted_poc_reward, GraphQL::Types::BigInt, null: true, description: "The boosted POC reward."
            field :seniority_timestamp, GraphQL::Types::ISO8601DateTime, null: true, description: "The seniority timestamp."
            field :coverage_object, String, null: true, description: "The coverage object data."
            field :location_trust_score_multiplier, GraphQL::Types::Float, null: true, description: "The location trust score multiplier."
            field :speedtest_multiplier, GraphQL::Types::Float, null: true, description: "The speedtest multiplier."
            field :sp_boosted_hex_status, String, null: true, description: "The service provider boosted hex status."
            field :oracle_boosted_hex_status, String, null: true, description: "The oracle boosted hex status."
          end

          class MobilePromotionRewardDetailType < Relay::Types::BaseObject
            description "Represents a mobile promotion reward share."

            field :entity, String, null: true, description: "The entity."
            field :service_provider_amount, GraphQL::Types::BigInt, null: true, description: "The service provider amount."
            field :matched_amount, GraphQL::Types::BigInt, null: true, description: "The matched amount."
          end

          class MobileRewardShareDetailType < Relay::Types::BaseUnion
            description "Represents different types of mobile reward data"
            possible_types MobileRadioRewardDetailType, MobileGatewayRewardDetailType,
                         MobileSubscriberRewardDetailType, MobileServiceProviderRewardDetailType,
                         MobileUnallocatedRewardDetailType, MobileRadioRewardV2ShareType,
                         MobilePromotionRewardDetailType

            class << self
              extend T::Sig

              sig do
                params(
                  object: Relay::Helium::L2::MobileRewardShare,
                  context: GraphQL::Query::Context
                ).returns(T.any(
                  T.class_of(MobileRadioRewardDetailType),
                  T.class_of(MobileGatewayRewardDetailType),
                  T.class_of(MobileSubscriberRewardDetailType),
                  T.class_of(MobileServiceProviderRewardDetailType),
                  T.class_of(MobileUnallocatedRewardDetailType),
                  T.class_of(MobileRadioRewardV2ShareType),
                  T.class_of(MobilePromotionRewardDetailType)
                ))
              end
              def resolve_type(object, context)
                case object.reward_type
                when "radio_reward"
                  MobileRadioRewardDetailType
                when "gateway_reward"
                  MobileGatewayRewardDetailType
                when "subscriber_reward"
                  MobileSubscriberRewardDetailType
                when "service_provider_reward"
                  MobileServiceProviderRewardDetailType
                when "unallocated_reward"
                  MobileUnallocatedRewardDetailType
                when "radio_reward_v2"
                  MobileRadioRewardV2ShareType
                when "promotion_reward"
                  MobilePromotionRewardDetailType
                else
                  raise "Unexpected reward type: #{object["reward_type"].inspect}"
                end
              end
            end
          end

          field :id, ID, null: false, description: "The unique identifier of the mobile reward share."
          field :reward_type, String, null: true, description: "The type of reward."
          field :start_period, GraphQL::Types::ISO8601DateTime, null: true, description: "The start period of the mobile reward share."
          field :end_period, GraphQL::Types::ISO8601DateTime, null: true, description: "The end period of the mobile reward share."
          field :manifest, RewardManifestType, null: true, description: "The reward manifest associated with this reward share."
          field :reward_detail, MobileRewardShareDetailType, null: true, description: "Type-specific details of this reward share."

          sig { returns(T.nilable(Relay::Helium::L2::RewardManifest)) }
          def manifest
            dataloader.with(Sources::RewardManifestByFileName).load(object.file_name)
          end

          sig { returns(T.nilable(Relay::Helium::L2::MobileRewardShare)) }
          def reward_detail
            object
          end
        end
      end
    end
  end
end
