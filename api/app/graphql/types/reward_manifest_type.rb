# typed: strict
# frozen_string_literal: true

module Types
  class RewardManifestType < Types::BaseObject
    extend T::Sig

    field :id, ID, null: false, description: "The unique identifier of the reward manifest."
    field :written_files, [ String ], null: true, description: "Array of written files associated with the reward manifest."
    field :start_timestamp, GraphQL::Types::ISO8601DateTime, null: true, description: "The start timestamp of the reward period."
    field :end_timestamp, GraphQL::Types::ISO8601DateTime, null: true, description: "The end timestamp of the reward period."
    field :reward_data, GraphQL::Types::JSON, null: true, description: "The reward data in JSON format."
    field :epoch, GraphQL::Types::BigInt, null: true, description: "The epoch number."
    field :price, GraphQL::Types::BigInt, null: true, description: "The price value."
    field :deduplication_key, String, null: false, description: "The unique key used for deduplication."
    field :file_category, String, null: false, description: "The category of the file."
    field :file_name, String, null: false, description: "The name of the file."
  end
end
