# typed: strict
# frozen_string_literal: true

module Relay
  module Types
    class QueryType < Types::BaseObject
      extend T::Sig

      field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
        argument :ids, [ ID ], required: true, description: "IDs of the objects."
      end

      sig { params(ids: T::Array[String]).returns(T::Array[Types::NodeType]) }
      def nodes(ids:)
        ids.map { |id| context.schema.object_from_id(id, context) }
      end

      field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
        argument :id, ID, required: true, description: "ID of the object."
      end

      sig { params(id: String).returns(Types::NodeType) }
      def node(id:)
        context.schema.object_from_id(id, context)
      end

      # Add root-level fields here.
      # They will be entry points for queries on your schema.

      field :echo, String, null: false, description: "Echoes the given message." do
        argument :message, String, required: true, description: "Message to echo"
      end

      sig { params(message: String).returns(String) }
      def echo(message:)
        message
      end

      field :status, String, null: false, description: "Retrieves the status of the API."

      sig { returns(String) }
      def status
        "ok"
      end

      field :iot_reward_shares, Helium::L2::Types::IotRewardShareType.connection_type, null: false, description: "Retrieves a list of IoT reward shares within a specified time period." do
        argument :start_period, GraphQL::Types::ISO8601DateTime, required: true, description: "Start of the time period to fetch reward shares for"
        argument :end_period, GraphQL::Types::ISO8601DateTime, required: true, description: "End of the time period to fetch reward shares for"
        argument :hotspot_key, String, required: false, description: "Hotspot key to filter by"
        argument :reward_type, String, required: false, description: "Reward type to filter by"
      end

      sig { params(start_period: Time, end_period: Time, hotspot_key: T.nilable(String), reward_type: T.nilable(String)).returns(ActiveRecord::Relation) }
      def iot_reward_shares(start_period:, end_period:, hotspot_key: nil, reward_type: nil)
        query = Helium::L2::IotRewardShare.where("end_period >= ?", start_period).where("end_period <= ?", end_period)
        query = query.where(hotspot_key: hotspot_key) if hotspot_key.present?
        query = query.where(reward_type: reward_type) if reward_type.present?
        query.order(end_period: :asc)
      end

      field :mobile_reward_shares, Helium::L2::Types::MobileRewardShareType.connection_type, null: false, description: "Retrieves a list of MOBILE reward shares within a specified time period." do
        argument :start_period, GraphQL::Types::ISO8601DateTime, required: true, description: "Start of the time period to fetch reward shares for"
        argument :end_period, GraphQL::Types::ISO8601DateTime, required: true, description: "End of the time period to fetch reward shares for"
        argument :hotspot_key, String, required: false, description: "Hotspot key to filter by"
        argument :reward_type, String, required: false, description: "Reward type to filter by"
      end

      sig { params(start_period: Time, end_period: Time, hotspot_key: T.nilable(String), reward_type: T.nilable(String)).returns(ActiveRecord::Relation) }
      def mobile_reward_shares(start_period:, end_period:, hotspot_key: nil, reward_type: nil)
        query = Helium::L2::MobileRewardShare.where("end_period >= ?", start_period).where("end_period <= ?", end_period)
        query = query.where(hotspot_key: hotspot_key) if hotspot_key.present?
        query = query.where(reward_type: reward_type) if reward_type.present?
        query.order(end_period: :asc)
      end

      field :reward_manifests, Helium::L2::Types::RewardManifestType.connection_type, null: false, description: "Retrieves a list of reward manifests within a specified time period." do
        argument :start_timestamp, GraphQL::Types::ISO8601DateTime, required: true, description: "Start of the time period to fetch reward manifests for"
        argument :end_timestamp, GraphQL::Types::ISO8601DateTime, required: true, description: "End of the time period to fetch reward manifests for"
      end

      sig { params(start_timestamp: Time, end_timestamp: Time).returns(ActiveRecord::Relation) }
      def reward_manifests(start_timestamp:, end_timestamp:)
        Helium::L2::RewardManifest
          .where("start_timestamp >= ?", start_timestamp)
          .where("end_timestamp <= ?", end_timestamp)
          .order(start_timestamp: :asc)
      end
    end
  end
end
