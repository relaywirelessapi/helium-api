# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class MobileRewardShareType < Relay::Types::BaseObject
          extend T::Sig

          field :id, ID, null: false, description: "The unique identifier of the IoT reward share."
          field :owner_key, String, null: true, description: "The owner key of the mobile reward share."
          field :hotspot_key, String, null: true, description: "The key of the hotspot."
          field :cbsd_id, String, null: true, description: "The CBSD ID."
          field :amount, GraphQL::Types::BigInt, null: true, description: "The amount of the reward."
          field :start_period, GraphQL::Types::ISO8601DateTime, null: true, description: "The start period of the mobile reward share."
          field :end_period, GraphQL::Types::ISO8601DateTime, null: true, description: "The end period of the mobile reward share."
          field :reward_type, String, null: true, description: "The type of reward."
          field :dc_transfer_reward, GraphQL::Types::BigInt, null: true, description: "The amount of DC transfer rewards."
          field :poc_reward, GraphQL::Types::BigInt, null: true, description: "The amount of POC rewards."
          field :subscriber_id, String, null: true, description: "The subscriber ID."
          field :subscriber_reward, GraphQL::Types::BigInt, null: true, description: "The amount of subscriber rewards."
          field :discovery_location_amount, GraphQL::Types::BigInt, null: true, description: "The amount of discovery location rewards."
          field :unallocated_reward_type, String, null: true, description: "The type of unallocated reward."
          field :service_provider_id, String, null: true, description: "The service provider ID."
          field :base_coverage_points_sum, GraphQL::Types::Float, null: true, description: "The sum of base coverage points."
          field :boosted_coverage_points_sum, GraphQL::Types::Float, null: true, description: "The sum of boosted coverage points."
          field :base_reward_shares, GraphQL::Types::Float, null: true, description: "The base reward shares."
          field :boosted_reward_shares, GraphQL::Types::Float, null: true, description: "The boosted reward shares."
          field :base_poc_reward, GraphQL::Types::BigInt, null: true, description: "The base POC reward."
          field :boosted_poc_reward, GraphQL::Types::BigInt, null: true, description: "The boosted POC reward."
          field :coverage_object, String, null: true, description: "The coverage object data."
          field :seniority_timestamp, GraphQL::Types::ISO8601DateTime, null: true, description: "The seniority timestamp."
          field :location_trust_score_multiplier, GraphQL::Types::Float, null: true, description: "The location trust score multiplier."
          field :speedtest_multiplier, GraphQL::Types::Float, null: true, description: "The speedtest multiplier."
          field :sp_boosted_hex_status, String, null: true, description: "The service provider boosted hex status."
          field :oracle_boosted_hex_status, String, null: true, description: "The oracle boosted hex status."
          field :entity, String, null: true, description: "The entity."
          field :service_provider_amount, GraphQL::Types::BigInt, null: true, description: "The service provider amount."
          field :matched_amount, GraphQL::Types::BigInt, null: true, description: "The matched amount."
          field :manifest, RewardManifestType, null: true, description: "The reward manifest associated with this reward share."

          sig { returns(T.nilable(Relay::Helium::L2::RewardManifest)) }
          def manifest
            dataloader.with(Sources::RewardManifestByFileName).load(object.file_name)
          end
        end
      end
    end
  end
end
