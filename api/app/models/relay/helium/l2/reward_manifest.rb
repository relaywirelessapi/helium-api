# typed: strict

module Relay
  module Helium
    module L2
      class RewardManifest < ApplicationRecord
        extend T::Sig

        include OracleData

        self.table_name = "helium_l2_reward_manifests"

        has_many(
          :files,
          class_name: "Relay::Helium::L2::RewardManifestFile",
          inverse_of: :reward_manifest
        )

        after_create_commit :refresh_reward_share_manifest_metadata

        sig { returns(T::Hash[Symbol, T.untyped]) }
        def metadata
          {
            price: price,
            token: reward_data["token"]
          }
        end

        sig { void }
        def refresh_reward_share_manifest_metadata
          RefreshRewardShareManifestMetadataJob.perform_later(self)
        end
      end
    end
  end
end
