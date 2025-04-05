# typed: strict

module Relay
  module Helium
    module L2
      class FileDefinition < StaticModel
        extend T::Sig

        sig { returns(T.nilable(Deserializers::BaseDeserializer)) }
        attr_reader :deserializer

        attribute :bucket, :string
        attribute :category, :string
        attribute :prefix, :string

        validates :bucket, presence: true
        validates :category, presence: true
        validates :prefix, presence: true

        class << self
          extend T::Sig

          sig { returns(T::Array[T.attached_class]) }
          def all
            [
              new(
                id: "foundation-iot-verified-rewards/iot_reward_share",
                bucket: "foundation-poc-data-requester-pays",
                category: "foundation-iot-verified-rewards",
                prefix: "iot_reward_share",
                deserializer: Relay::Helium::L2::Deserializers::IotRewardShareDeserializer.new
              ),
              new(
                id: "foundation-mobile-verified/mobile_reward_share",
                bucket: "foundation-poc-data-requester-pays",
                category: "foundation-mobile-verified",
                prefix: "mobile_reward_share",
                deserializer: Relay::Helium::L2::Deserializers::MobileRewardShareDeserializer.new
              )
              # new(
              #   id: "foundation-iot-ingest/iot_witness_ingest_report",
              #   bucket: "foundation-poc-data-requester-pays",
              #   category: "foundation-iot-ingest",
              #   prefix: "iot_witness_ingest_report",
              #   deserializer: Relay::Helium::L2::Deserializers::IotWitnessIngestReportDeserializer.new
              # ),
              # new(
              #   id: "foundation-iot-ingest/iot_beacon_ingest_report",
              #   bucket: "foundation-poc-data-requester-pays",
              #   category: "foundation-iot-ingest",
              #   prefix: "iot_beacon_ingest_report",
              #   deserializer: Relay::Helium::L2::Deserializers::IotBeaconIngestReportDeserializer.new
              # )
            ]
          end
        end

        sig { params(deserializer: T.nilable(Deserializers::BaseDeserializer), kwargs: T.untyped).void }
        def initialize(deserializer: nil, **kwargs)
          super(**kwargs)
          @deserializer = T.let(deserializer, T.nilable(Deserializers::BaseDeserializer))
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
