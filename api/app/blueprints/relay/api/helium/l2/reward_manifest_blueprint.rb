# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class RewardManifestBlueprint < Blueprinter::Base
          class IotRewardDetailBlueprint < Blueprinter::Base
            field :token
            field :poc_bones_per_beacon_reward_share
            field :poc_bones_per_witness_reward_share
            field :dc_bones_per_share
          end

          class MobileRewardDetailBlueprint < Blueprinter::Base
            class ServiceProviderPromotionBlueprint < Blueprinter::Base
              class PromotionDetailBlueprint < Blueprinter::Base
                field :entity
                field :start_ts
                field :end_ts
                field :shares
              end

              field :service_provider
              field :incentive_escrow_fund_bps

              association :promotions, blueprint: PromotionDetailBlueprint do |object|
                object.promotions.map { |p| OpenStruct.new(p) }
              end
            end

            field :token
            field :poc_bones_per_reward_share
            field :boosted_poc_bones_per_reward_share

            association :service_provider_promotions, blueprint: ServiceProviderPromotionBlueprint do |object|
              object.service_provider_promotions.map { |p| OpenStruct.new(p) }
            end
          end

          identifier :id

          field :written_files
          field :start_timestamp
          field :end_timestamp
          field :epoch
          field :price
          field :reward_type do |object|
            object.reward_data["reward_type"]
          end

          association :reward_detail, blueprint: ->(object) {
            case object.reward_type
            when "iot"
              IotRewardDetailBlueprint
            when "mobile"
              MobileRewardDetailBlueprint
            else
              raise "Unexpected reward type: #{object.reward_type.inspect}"
            end
          } do |object|
            OpenStruct.new(object.reward_data)
          end
        end
      end
    end
  end
end
