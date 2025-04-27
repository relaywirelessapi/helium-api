# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class IotRewardShareType < Relay::Types::BaseObject
          extend T::Sig

          field :start_period, GraphQL::Types::ISO8601DateTime, null: true, description: "The start period of the iot reward share."
          field :end_period, GraphQL::Types::ISO8601DateTime, null: true, description: "The end period of the iot reward share."
          field :reward_type, String, null: true, description: "The type of reward."
          field :unallocated_reward_type, String, null: true, description: "The type of unallocated reward."
          field :amount, GraphQL::Types::BigInt, null: true, description: "The amount of the reward."
          field :hotspot_key, String, null: true, description: "The key of the hotspot."
          field :beacon_amount, GraphQL::Types::BigInt, null: true, description: "The amount of beacon rewards."
          field :witness_amount, GraphQL::Types::BigInt, null: true, description: "The amount of witness rewards."
          field :dc_transfer_amount, GraphQL::Types::BigInt, null: true, description: "The amount of DC transfer rewards."
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
