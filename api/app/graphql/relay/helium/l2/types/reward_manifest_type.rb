# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class RewardManifestType < Relay::Types::BaseObject
          extend T::Sig

          field :id, ID, null: false, description: "The unique identifier of the reward manifest."
          field :written_files, [ String ], null: true, description: "Array of written files associated with the reward manifest."
          field :start_timestamp, GraphQL::Types::ISO8601DateTime, null: true, description: "The start timestamp of the reward period."
          field :end_timestamp, GraphQL::Types::ISO8601DateTime, null: true, description: "The end timestamp of the reward period."
          field :reward_data, RewardManifestDataType, null: true, description: "The reward data, either for mobile or IoT."
          field :epoch, GraphQL::Types::BigInt, null: true, description: "The epoch number."
          field :price, GraphQL::Types::BigInt, null: true, description: "The price value."
        end
      end
    end
  end
end
