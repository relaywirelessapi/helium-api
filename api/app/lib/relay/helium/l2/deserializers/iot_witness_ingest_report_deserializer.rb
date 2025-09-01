# typed: strict

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_lora_pb")

module Relay
  module Helium
    module L2
      module Deserializers
        class IotWitnessIngestReportDeserializer < BaseDeserializer
          extend T::Sig

          sig { returns(Relay::Base58Encoder) }
          attr_reader :base58_encoder

          sig { returns(Relay::Importing::BatchImporter) }
          attr_reader :batch_importer

          sig { params(base58_encoder: Relay::Base58Encoder, batch_importer: Relay::Importing::BatchImporter).void }
          def initialize(base58_encoder: Relay::Base58Encoder.new, batch_importer: Relay::Importing::BatchImporter.new)
            @base58_encoder = base58_encoder
            @batch_importer = batch_importer
          end

          sig { override.params(encoded_message: String, file: File).returns(T::Hash[Symbol, T.untyped]) }
          def deserialize(encoded_message, file:)
            message = ::Helium::PocLora::Lora_witness_ingest_report_v1.decode(encoded_message)

            {
              received_at: Time.zone.at(message.received_timestamp / 10**3),
              hotspot_key: base58_encoder.base58check_from_data("\x00#{message.report.pub_key}"),
              data: message.report.data,
              reported_at: Time.zone.at(message.report.timestamp / 10**9),
              tmst: message.report.tmst,
              signal: message.report.signal,
              snr: message.report.snr,
              frequency: message.report.frequency,
              data_rate: message.report.datarate,
              signature: message.report.signature,
              file_category: file.category,
              file_name: file.name
            }
          end

          sig { override.params(messages: T::Array[T::Hash[Symbol, T.untyped]]).void }
          def import(messages)
            batch_importer.import(Relay::Helium::L2::IotWitnessIngestReport, messages)
          end
        end
      end
    end
  end
end
