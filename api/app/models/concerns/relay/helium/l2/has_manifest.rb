# typed: false

module Relay
  module Helium
    module L2
      module HasManifest
        extend ActiveSupport::Concern

        included do
          belongs_to(
            :reward_manifest_file,
            class_name: "Helium::L2::RewardManifestFile",
            foreign_key: :file_name,
            primary_key: :file_name,
            inverse_of: false,
            optional: true
          )

          has_one(
            :reward_manifest,
            through: :reward_manifest_file,
            source: :reward_manifest
          )
        end

        private

        def format_amount_for_manifest_token(amount)
          return unless reward_manifest

          case reward_manifest.reward_data["token"]
          when "iot_reward_token_hnt", "mobile_reward_token_hnt"
            (amount.to_f / 10**8).to_s
          when "iot_reward_token_iot"
            (amount.to_f / 10**6).to_s
          when "mobile_reward_token_mobile"
            (amount.to_f / 10**6).to_s
          else
            Sentry.capture_message("Unknown token in reward manifest: #{reward_manifest.reward_data["token"]}",
              extra: {
                record_id: to_global_id
              }
            )
            nil
          end
        end
      end
    end
  end
end
