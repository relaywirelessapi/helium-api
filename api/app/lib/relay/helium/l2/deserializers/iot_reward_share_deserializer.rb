# typed: strict

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_lora_pb")

module Relay
  module Helium
    module L2
      module Deserializers
        class IotRewardShareDeserializer < BaseDeserializer
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

          sig { override.params(encoded_message: String, file: File).returns(T::Hash[Symbol, T.untyped]) }
          def deserialize(encoded_message, file:)
            message = ::Helium::PocLora::Iot_reward_share.decode(encoded_message)

            attributes = case message.reward
            when :gateway_reward
              {
                hotspot_key: base58_encoder.base58check_from_data("\x00#{message.gateway_reward.hotspot_key}"),
                beacon_amount: message.gateway_reward.beacon_amount,
                witness_amount: message.gateway_reward.witness_amount,
                dc_transfer_amount: message.gateway_reward.dc_transfer_amount
              }
            when :operational_reward
              {
                amount: message.operational_reward.amount
              }
            when :unallocated_reward
              {
                unallocated_reward_type: message.unallocated_reward.reward_type,
                amount: message.unallocated_reward.amount
              }
            else
              raise "Cannot sync reward type `#{message.reward}`"
            end

            {
              **attributes,
              reward_type: message.reward,
              start_period: Time.zone.at(message.start_period),
              end_period: Time.zone.at(message.end_period),
              file_category: file.category,
              file_name: file.name
            }
          end

          sig { override.params(messages: T::Array[T::Hash[Symbol, T.untyped]]).void }
          def import(messages)
            batch_importer.import(Relay::Helium::L2::IotRewardShare, messages)
          end
        end
      end
    end
  end
end
