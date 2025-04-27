# typed: strict

module Relay
  module Helium
    module L2
      class RewardManifest < ApplicationRecord
        include OracleData

        self.table_name = "helium_l2_reward_manifests"

        has_many(
          :files,
          class_name: "Relay::Helium::L2::RewardManifestFile",
          inverse_of: :reward_manifest
        )
      end
    end
  end
end
