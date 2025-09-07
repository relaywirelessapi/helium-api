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

        after_create_commit :schedule_offload_calculation

        scope :by_file, ->(file) { where(file_name: file.file_name) }
        scope :pending_offload_calculation, -> { where("dc_transfer_reward IS NOT NULL AND offloaded_bytes IS NULL") }

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

        sig { void }
        def refresh_offloaded_bytes
          return unless dc_transfer_reward && reward_manifest&.price

          offloaded_gbs = dc_transfer_reward.to_f / T.must(reward_manifest).price.to_f / DOLLARS_PER_OFFLOADED_GB
          self.offloaded_bytes = (offloaded_gbs * 1024**3).round.to_i
        end

        sig { void }
        def refresh_offloaded_bytes!
          refresh_offloaded_bytes
          save!
        end

        private

        sig { void }
        def schedule_offload_calculation
          Relay::Helium::L2::CalculateMobileOffloadJob.perform_later(self)
        end
      end
    end
  end
end
