# typed: strict

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_mobile_pb")

module Relay
  module Helium
    module L2
      module Deserializers
        class MobileRewardShareDeserializer < BaseDeserializer
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
            message = ::Helium::PocMobile::Mobile_reward_share.decode(encoded_message)

            attributes = case message.reward.to_sym
            when :radio_reward
              {
                hotspot_key: base58_encoder.base58check_from_data("\x00#{message.radio_reward.hotspot_key}"),
                cbsd_id: message.radio_reward.cbsd_id,
                dc_transfer_reward: message.radio_reward.dc_transfer_reward,
                poc_reward: message.radio_reward.poc_reward
              }
            when :gateway_reward
              {
                hotspot_key: base58_encoder.base58check_from_data("\x00#{message.gateway_reward.hotspot_key}"),
                dc_transfer_reward: message.gateway_reward.dc_transfer_reward
              }
            when :subscriber_reward
              {
                subscriber_id: base58_encoder.base58check_from_data("\x00#{message.subscriber_reward.subscriber_id}"),
                discovery_location_amount: message.subscriber_reward.discovery_location_amount
              }
            when :service_provider_reward
              {
                service_provider_id: message.service_provider_reward.service_provider_id,
                amount: message.service_provider_reward.amount
              }
            when :unallocated_reward
              {
                unallocated_reward_type: message.unallocated_reward.reward_type,
                amount: message.unallocated_reward.amount
              }
            when :radio_reward_v2
              {
                hotspot_key: base58_encoder.base58check_from_data("\x00#{message.radio_reward_v2.hotspot_key}"),
                cbsd_id: message.radio_reward_v2.cbsd_id,
                base_coverage_points_sum: message.radio_reward_v2.base_coverage_points_sum.value,
                boosted_coverage_points_sum: message.radio_reward_v2.boosted_coverage_points_sum.value,
                base_reward_shares: message.radio_reward_v2.base_reward_shares.value,
                boosted_reward_shares: message.radio_reward_v2.boosted_reward_shares.value,
                base_poc_reward: message.radio_reward_v2.base_poc_reward,
                boosted_poc_reward: message.radio_reward_v2.boosted_poc_reward,
                seniority_timestamp: Time.zone.at(message.radio_reward_v2.seniority_timestamp),
                coverage_object: message.radio_reward_v2.coverage_object,
                location_trust_score_multiplier: message.radio_reward_v2.location_trust_score_multiplier.value,
                speedtest_multiplier: message.radio_reward_v2.speedtest_multiplier.value,
                sp_boosted_hex_status: message.radio_reward_v2.sp_boosted_hex_status,
                oracle_boosted_hex_status: message.radio_reward_v2.oracle_boosted_hex_status
              }
            when :promotion_reward
              {
                entity: message.promotion_reward.entity,
                service_provider_amount: message.promotion_reward.service_provider_amount,
                matched_amount: message.promotion_reward.matched_amount
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
            batch_importer.import(Relay::Helium::L2::MobileRewardShare, messages)
          end
        end
      end
    end
  end
end
