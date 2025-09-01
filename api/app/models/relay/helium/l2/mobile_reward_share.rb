# typed: strict

module Relay
  module Helium
    module L2
      class MobileRewardShare < ApplicationRecord
        extend T::Sig

        include OracleData
        include HasManifest

        DOLLARS_PER_OFFLOADED_GB = 0.50

        self.table_name = "helium_l2_mobile_reward_shares"

        sig { returns(T.nilable(String)) }
        def formatted_amount
          format_amount_for_manifest_token(amount)
        end

        sig { returns(T.nilable(String)) }
        def formatted_dc_transfer_reward
          format_amount_for_manifest_token(dc_transfer_reward)
        end

        sig { returns(T.nilable(String)) }
        def formatted_poc_reward
          format_amount_for_manifest_token(poc_reward)
        end

        sig { returns(T.nilable(String)) }
        def formatted_subscriber_reward
          format_amount_for_manifest_token(subscriber_reward)
        end

        sig { returns(T.nilable(String)) }
        def formatted_discovery_location_amount
          format_amount_for_manifest_token(discovery_location_amount)
        end

        sig { returns(T.nilable(Float)) }
        def offloaded_data_gbs
          return unless dc_transfer_reward && reward_manifest_metadata && reward_manifest_metadata["price"]

          dc_transfer_reward_in_dollars = dc_transfer_reward.to_f / reward_manifest_metadata.fetch("price").to_f
          dc_transfer_reward_in_dollars / DOLLARS_PER_OFFLOADED_GB
        end
      end
    end
  end
end
