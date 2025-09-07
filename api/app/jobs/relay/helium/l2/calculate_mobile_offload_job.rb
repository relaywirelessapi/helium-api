# typed: strict

module Relay
  module Helium
    module L2
      class CalculateMobileOffloadJob < ApplicationJob
        extend T::Sig

        queue_as :low

        sig { params(reward_manifest_file: Relay::Helium::L2::RewardManifestFile).void }
        def perform(reward_manifest_file)
          Relay::Helium::L2::MobileRewardShare.by_file(reward_manifest_file).pending_offload_calculation.find_each do |mobile_reward_share|
            mobile_reward_share.refresh_offloaded_bytes!
          end
        end
      end
    end
  end
end
