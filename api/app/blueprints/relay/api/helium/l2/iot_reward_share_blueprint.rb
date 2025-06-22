# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class IotRewardShareBlueprint < Blueprinter::Base
          class GatewayRewardDetailBlueprint < Blueprinter::Base
            field :hotspot_key
            field :beacon_amount
            field :witness_amount
            field :dc_transfer_amount
            field :formatted_beacon_amount
            field :formatted_witness_amount
            field :formatted_dc_transfer_amount
          end

          class OperationalRewardDetailBlueprint < Blueprinter::Base
            field :amount
            field :formatted_amount
          end

          class UnallocatedRewardDetailBlueprint < Blueprinter::Base
            field :unallocated_reward_type
            field :amount
            field :formatted_amount
          end

          identifier :id

          field :reward_type
          field :start_period
          field :end_period

          association :reward_manifest, blueprint: RewardManifestBlueprint
          association :reward_detail, blueprint: ->(object) {
            case object.reward_type
            when "gateway_reward"
              GatewayRewardDetailBlueprint
            when "operational_reward"
              OperationalRewardDetailBlueprint
            when "unallocated_reward"
              UnallocatedRewardDetailBlueprint
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
