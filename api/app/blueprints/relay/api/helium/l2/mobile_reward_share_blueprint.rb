# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class MobileRewardShareBlueprint < Blueprinter::Base
          class RadioRewardDetailBlueprint < Blueprinter::Base
            field :hotspot_key
            field :cbsd_id
            field :dc_transfer_reward
            field :formatted_dc_transfer_reward
            field :poc_reward
            field :formatted_poc_reward
            field :offloaded_bytes
          end

          class GatewayRewardDetailBlueprint < Blueprinter::Base
            field :hotspot_key
            field :dc_transfer_reward
            field :formatted_dc_transfer_reward
            field :offloaded_bytes
          end

          class SubscriberRewardDetailBlueprint < Blueprinter::Base
            field :subscriber_id
            field :discovery_location_amount
            field :formatted_discovery_location_amount
            field :subscriber_reward
            field :formatted_subscriber_reward
          end

          class ServiceProviderRewardDetailBlueprint < Blueprinter::Base
            field :service_provider_id
            field :amount
            field :formatted_amount
          end

          class UnallocatedRewardDetailBlueprint < Blueprinter::Base
            field :unallocated_reward_type
            field :amount
            field :formatted_amount
          end

          class RadioRewardV2ShareBlueprint < Blueprinter::Base
            field :hotspot_key
            field :cbsd_id
            field :base_coverage_points_sum
            field :boosted_coverage_points_sum
            field :base_reward_shares
            field :boosted_reward_shares
            field :base_poc_reward
            field :boosted_poc_reward
            field :seniority_timestamp
            field :coverage_object do |object|
              Base64.strict_encode64(object.coverage_object)
            end
            field :location_trust_score_multiplier
            field :speedtest_multiplier
            field :sp_boosted_hex_status
            field :oracle_boosted_hex_status
          end

          class PromotionRewardDetailBlueprint < Blueprinter::Base
            field :entity
            field :service_provider_amount
            field :matched_amount
          end

          identifier :id

          field :reward_type
          field :start_period
          field :end_period

          association :reward_manifest, blueprint: RewardManifestBlueprint
          association :reward_detail, blueprint: ->(object) {
            case object.reward_type
            when "radio_reward"
              RadioRewardDetailBlueprint
            when "gateway_reward"
              GatewayRewardDetailBlueprint
            when "subscriber_reward"
              SubscriberRewardDetailBlueprint
            when "service_provider_reward"
              ServiceProviderRewardDetailBlueprint
            when "unallocated_reward"
              UnallocatedRewardDetailBlueprint
            when "radio_reward_v2"
              RadioRewardV2ShareBlueprint
            when "promotion_reward"
              PromotionRewardDetailBlueprint
            else
              raise "Unexpected reward type: #{object.reward_type.inspect}"
            end
          } do |object|
            object
          end
        end
      end
    end
  end
end
