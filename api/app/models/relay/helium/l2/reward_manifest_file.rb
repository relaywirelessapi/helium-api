# typed: strict

module Relay
  module Helium
    module L2
      class RewardManifestFile < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l2_reward_manifest_files"
        self.primary_key = [ "reward_manifest_id", "file_name" ]

        belongs_to(
          :reward_manifest,
          class_name: "Relay::Helium::L2::RewardManifest",
          inverse_of: :files
        )

        after_create_commit :schedule_mobile_offload_calculations

        private

        sig { void }
        def schedule_mobile_offload_calculations
          Relay::Helium::L2::CalculateMobileOffloadJob.perform_later(self)
        end
      end
    end
  end
end
