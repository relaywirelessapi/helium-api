# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class IotRewardShareType < Relay::Types::BaseObject
          extend T::Sig

          class IotGatewayRewardDetailType < Relay::Types::BaseObject
            description "Represents an IoT gateway reward share."

            field :hotspot_key, String, null: true, description: "The key of the hotspot."
            field :beacon_amount, GraphQL::Types::BigInt, null: true, description: "The amount of beacon rewards."
            field :witness_amount, GraphQL::Types::BigInt, null: true, description: "The amount of witness rewards."
            field :dc_transfer_amount, GraphQL::Types::BigInt, null: true, description: "The amount of DC transfer rewards."
            field :formatted_beacon_amount, String, null: true, description: "The formatted amount of beacon rewards."
            field :formatted_witness_amount, String, null: true, description: "The formatted amount of witness rewards."
            field :formatted_dc_transfer_amount, String, null: true, description: "The formatted amount of DC transfer rewards."
          end

          class IotOperationalRewardDetailType < Relay::Types::BaseObject
            description "Represents an IoT operational reward share."

            field :amount, GraphQL::Types::BigInt, null: true, description: "The amount of the reward."
            field :formatted_amount, String, null: true, description: "The formatted amount of the reward."
          end

          class IotUnallocatedRewardDetailType < Relay::Types::BaseObject
            description "Represents an IoT unallocated reward share."

            field :unallocated_reward_type, String, null: true, description: "The type of unallocated reward."
            field :amount, GraphQL::Types::BigInt, null: true, description: "The amount of the reward."
            field :formatted_amount, String, null: true, description: "The formatted amount of the reward."
          end

          class IotRewardShareDetailType < Relay::Types::BaseUnion
            description "Represents either mobile or IoT reward data"
            possible_types IotGatewayRewardDetailType, IotOperationalRewardDetailType, IotUnallocatedRewardDetailType

            class << self
              extend T::Sig

              sig do
                params(
                  object: Relay::Helium::L2::IotRewardShare,
                  context: GraphQL::Query::Context
                ).returns(T.any(
                  T.class_of(IotGatewayRewardDetailType),
                  T.class_of(IotOperationalRewardDetailType),
                  T.class_of(IotUnallocatedRewardDetailType)
                ))
              end
              def resolve_type(object, context)
                case object.reward_type
                when "gateway_reward"
                  IotGatewayRewardDetailType
                when "operational_reward"
                  IotOperationalRewardDetailType
                when "unallocated_reward"
                  IotUnallocatedRewardDetailType
                else
                  raise "Unexpected reward type: #{object["reward_type"].inspect}"
                end
              end
            end
          end

          field :id, ID, null: false, description: "The unique identifier of the IoT reward share."
          field :reward_type, String, null: true, description: "The type of reward."
          field :start_period, GraphQL::Types::ISO8601DateTime, null: true, description: "The start period of the iot reward share."
          field :end_period, GraphQL::Types::ISO8601DateTime, null: true, description: "The end period of the iot reward share."
          field :manifest, RewardManifestType, null: true, description: "The reward manifest associated with this reward share."
          field :reward_detail, IotRewardShareDetailType, null: true, description: "Type-specific details of this reward share."

          sig { returns(T.nilable(Relay::Helium::L2::RewardManifest)) }
          def manifest
            dataloader.with(Sources::RewardManifestByFileName).load(object.file_name)
          end

          sig { returns(T.nilable(Relay::Helium::L2::IotRewardShare)) }
          def reward_detail
            object
          end
        end
      end
    end
  end
end
