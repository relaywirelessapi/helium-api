# typed: strict

module Relay
  module Helium
    module L2
      class IotRewardShare < ApplicationRecord
        extend T::Sig

        include OracleData
        include HasManifest

        self.table_name = "helium_l2_iot_reward_shares"

        sig { returns(T.nilable(String)) }
        def formatted_beacon_amount
          format_amount_for_manifest_token(beacon_amount)
        end

        sig { returns(T.nilable(String)) }
        def formatted_witness_amount
          format_amount_for_manifest_token(witness_amount)
        end

        sig { returns(T.nilable(String)) }
        def formatted_dc_transfer_amount
          format_amount_for_manifest_token(dc_transfer_amount)
        end

        sig { returns(T.nilable(String)) }
        def formatted_amount
          format_amount_for_manifest_token(amount)
        end
      end
    end
  end
end
