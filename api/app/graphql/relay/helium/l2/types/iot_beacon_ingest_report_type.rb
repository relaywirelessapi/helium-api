# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      module Types
        class IotBeaconIngestReportType < Relay::Types::BaseObject
          extend T::Sig

          field :received_at, GraphQL::Types::ISO8601DateTime, null: true, description: "The timestamp when the beacon ingest report was received."
          field :hotspot_key, String, null: true, description: "The key of the hotspot."
          field :data, Relay::Types::BinaryType, null: true, description: "The data of the beacon ingest report."
          field :reported_at, GraphQL::Types::ISO8601DateTime, null: true, description: "The timestamp when the beacon ingest report was reported."
          field :tmst, GraphQL::Types::BigInt, null: true, description: "The timestamp of the beacon ingest report."
          field :frequency, GraphQL::Types::BigInt, null: true, description: "The frequency of the beacon ingest report."
          field :data_rate, String, null: true, description: "The data rate of the beacon ingest report."
          field :tx_power, GraphQL::Types::BigInt, null: true, description: "The transmission power of the beacon ingest report."
          field :local_entropy, Relay::Types::BinaryType, null: true, description: "The local entropy of the beacon ingest report."
          field :remote_entropy, Relay::Types::BinaryType, null: true, description: "The remote entropy of the beacon ingest report."
          field :signature, Relay::Types::BinaryType, null: true, description: "The signature of the beacon ingest report."
        end
      end
    end
  end
end
