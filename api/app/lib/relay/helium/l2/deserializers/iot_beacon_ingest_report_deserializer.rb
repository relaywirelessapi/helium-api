# typed: strict

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_lora_pb")

module Relay
  module Helium
    module L2
      module Deserializers
        class IotBeaconIngestReportDeserializer < BaseDeserializer
          extend T::Sig

          sig { returns(Relay::Base58Encoder) }
          attr_reader :base58_encoder

          sig { returns(Relay::BatchImporter) }
          attr_reader :batch_importer

          sig { params(base58_encoder: Relay::Base58Encoder, batch_importer: Relay::BatchImporter).void }
          def initialize(base58_encoder: Relay::Base58Encoder.new, batch_importer: Relay::BatchImporter.new)
            @base58_encoder = base58_encoder
            @batch_importer = batch_importer
          end

          sig { override.params(encoded_message: String).returns(T::Hash[Symbol, T.untyped]) }
          def deserialize(encoded_message)
            message = ::Helium::PocLora::Lora_beacon_ingest_report_v1.decode(encoded_message)

            {
              received_timestamp: Time.zone.at(message.received_timestamp / 10**3),
              pub_key: base58_encoder.base58check_from_data("\x00#{message.report.pub_key}"),
              data: message.report.data,
              timestamp: Time.zone.at(message.report.timestamp / 10**9),
              tmst: message.report.tmst,
              frequency: message.report.frequency,
              datarate: message.report.datarate,
              tx_power: message.report.tx_power,
              local_entropy: message.report.local_entropy,
              remote_entropy: message.report.remote_entropy,
              signature: message.report.signature
            }
          end

          sig { override.params(messages: T::Array[T::Hash[Symbol, T.untyped]]).void }
          def import(messages)
            batch_importer.import(Relay::Helium::L2::IotBeaconIngestReport, messages)
          end
        end
      end
    end
  end
end
