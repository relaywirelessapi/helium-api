# typed: false

module Relay
  module Helium
    module L2
      class RewardManifestFile < ApplicationRecord
        self.table_name = "helium_l2_reward_manifest_files"

        belongs_to(
          :reward_manifest,
          class_name: "Relay::Helium::L2::RewardManifest",
          inverse_of: :files
        )
      end
    end
  end
end
