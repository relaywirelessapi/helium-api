# typed: strict

module Relay
  module Helium
    module L2
      class MobileRewardShare < ApplicationRecord
        extend T::Sig

        include OracleData
        include HasManifest

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
      end
    end
  end
end
