# typed: strict

module Relay
  module Helium
    module L2
      class RefreshRewardShareManifestMetadataJob < ApplicationJob
        extend T::Sig

        queue_as :default

        REWARD_SHARE_MODELS = [ IotRewardShare, MobileRewardShare ].freeze

        sig { params(reward_manifest: Relay::Helium::L2::RewardManifest).void }
        def perform(reward_manifest)
          REWARD_SHARE_MODELS.each do |reward_share_model|
            records = reward_share_model.where(file_name: reward_manifest.files.map(&:file_name))
            records.update_all(reward_manifest_metadata: reward_manifest.metadata)
          end
        end
      end
    end
  end
end
