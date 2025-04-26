# typed: strict

require_dependency Rails.root.join("vendor/helium-protobuf/reward_manifest_pb")

module Relay
  module Helium
    module L2
      module Deserializers
        class RewardManifestDeserializer < BaseDeserializer
          extend T::Sig

          sig { returns(Relay::BatchImporter) }
          attr_reader :batch_importer

          sig { params(batch_importer: Relay::BatchImporter).void }
          def initialize(batch_importer: Relay::BatchImporter.new)
            @batch_importer = batch_importer
          end

          sig { override.params(encoded_message: String, file: File).returns(T::Hash[Symbol, T.untyped]) }
          def deserialize(encoded_message, file:)
            message = ::Helium::Reward_manifest.decode(encoded_message)

            reward_data = case message.reward_data
            when :mobile_reward_data
              {
                reward_type: :mobile,
                poc_bones_per_reward_share: message.mobile_reward_data.poc_bones_per_reward_share.value,
                boosted_poc_bones_per_reward_share: message.mobile_reward_data.boosted_poc_bones_per_reward_share.value,
                service_provider_promotions: message.mobile_reward_data.service_provider_promotions.map do |promo|
                  {
                    service_provider: promo.service_provider,
                    incentive_escrow_fund_bps: promo.incentive_escrow_fund_bps,
                    promotions: promo.promotions.map do |p|
                      {
                        entity: p.entity,
                        start_ts: Time.zone.at(p.start_ts),
                        end_ts: Time.zone.at(p.end_ts),
                        shares: p.shares
                      }
                    end
                  }
                end,
                token: message.mobile_reward_data.token
              }
            when :iot_reward_data
              {
                reward_type: :iot,
                poc_bones_per_beacon_reward_share: message.iot_reward_data.poc_bones_per_beacon_reward_share.value,
                poc_bones_per_witness_reward_share: message.iot_reward_data.poc_bones_per_witness_reward_share.value,
                dc_bones_per_share: message.iot_reward_data.dc_bones_per_share.value,
                token: message.iot_reward_data.token
              }
            when nil
              {}
            else
              raise "Cannot sync manifest reward data `#{message.reward_data}`"
            end

            {
              written_files: message.written_files.to_a,
              start_timestamp: Time.zone.at(message.start_timestamp),
              end_timestamp: Time.zone.at(message.end_timestamp),
              epoch: message.epoch == 0 ? nil : message.epoch,
              price: message.price == 0 ? nil : message.price,
              reward_data: reward_data,
              file_category: file.category,
              file_name: file.name
            }
          end

          sig { override.params(messages: T::Array[T::Hash[Symbol, T.untyped]]).void }
          def import(messages)
            batch_importer.import(Relay::Helium::L2::RewardManifest, messages)
          end
        end
      end
    end
  end
end
