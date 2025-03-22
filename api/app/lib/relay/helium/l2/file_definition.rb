# typed: strict

module Relay
  module Helium
    module L2
      class FileDefinition
        extend T::Sig

        include GlobalID::Identification

        sig { returns(String) }
        attr_accessor :bucket

        sig { returns(String) }
        attr_accessor :category

        sig { returns(String) }
        attr_accessor :prefix

        sig { returns(Deserializers::BaseDeserializer) }
        attr_accessor :deserializer

        class << self
          extend T::Sig

          sig { returns(T::Array[FileDefinition]) }
          def all
            [
              new(
                bucket: "foundation-poc-data-requester-pays",
                category: "foundation-iot-verified-rewards",
                prefix: "iot_reward_share",
                deserializer: Relay::Helium::L2::Deserializers::IotRewardShareDeserializer.new
              ),
              new(
                bucket: "foundation-poc-data-requester-pays",
                category: "foundation-mobile-verified",
                prefix: "mobile_reward_share",
                deserializer: Relay::Helium::L2::Deserializers::MobileRewardShareDeserializer.new
              ),
              new(
                bucket: "foundation-poc-data-requester-pays",
                category: "foundation-iot-ingest",
                prefix: "iot_witness_ingest_report",
                deserializer: Relay::Helium::L2::Deserializers::IotWitnessIngestReportDeserializer.new
              ),
              new(
                bucket: "foundation-poc-data-requester-pays",
                category: "foundation-iot-ingest",
                prefix: "iot_beacon_ingest_report",
                deserializer: Relay::Helium::L2::Deserializers::IotBeaconIngestReportDeserializer.new
              )
            ]
          end

          sig { params(id: String).returns(T.nilable(FileDefinition)) }
          def find(id)
            all.find { |definition| definition.id == id }
          end

          sig { params(id: String).returns(T.nilable(FileDefinition)) }
          def find_by_id(id)
            find(id)
          end

          sig { params(id: String).returns(FileDefinition) }
          def find!(id)
            find(id) || raise(FileDefinitionNotFoundError, "File definition not found: #{id}")
          end
        end

        sig { params(bucket: String, category: String, prefix: String, deserializer: Deserializers::BaseDeserializer).void }
        def initialize(bucket:, category:, prefix:, deserializer:)
          @category = category
          @prefix = prefix
          @deserializer = deserializer
          @bucket = bucket
        end

        sig { returns(String) }
        def id
          s3_prefix
        end

        sig { returns(T.nilable(File)) }
        def last_pulled_file
          File.where(definition_id: id).order(created_at: :desc).first
        end

        sig { returns(String) }
        def s3_prefix
          "#{category}/#{prefix}"
        end
      end
    end
  end
end
