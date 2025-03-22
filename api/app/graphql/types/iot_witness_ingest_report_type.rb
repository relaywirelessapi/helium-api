# typed: strict
# frozen_string_literal: true

module Types
  class IotWitnessIngestReportType < Types::BaseObject
    extend T::Sig

    field :received_at, GraphQL::Types::ISO8601DateTime, null: true, description: "The timestamp when the witness ingest report was received."
    field :hotspot_key, String, null: true, description: "The key of the hotspot."
    field :data, String, null: true, description: "The data of the witness ingest report."
    field :reported_at, GraphQL::Types::ISO8601DateTime, null: true, description: "The timestamp when the witness ingest report was reported."
    field :tmst, GraphQL::Types::BigInt, null: true, description: "The timestamp of the witness ingest report."
    field :signal, GraphQL::Types::BigInt, null: true, description: "The signal strength of the witness ingest report."
    field :snr, GraphQL::Types::BigInt, null: true, description: "The signal-to-noise ratio of the witness ingest report."
    field :frequency, GraphQL::Types::BigInt, null: true, description: "The frequency of the witness ingest report."
    field :data_rate, String, null: true, description: "The data rate of the witness ingest report."
    field :signature, String, null: true, description: "The signature of the witness ingest report."
  end
end
