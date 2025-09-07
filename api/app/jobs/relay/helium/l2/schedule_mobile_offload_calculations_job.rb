# typed: strict

module Relay
  module Helium
    module L2
      class ScheduleMobileOffloadCalculationsJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { params(reward_manifest_file: Relay::Helium::L2::RewardManifestFile).void }
        def perform(reward_manifest_file)
          Relay::Helium::L2::MobileRewardShare.by_file(reward_manifest_file).pending_offload_calculation.find_each do |mobile_reward_share|
            Relay::Helium::L2::CalculateMobileOffloadJob.perform_later(mobile_reward_share)
          end
        end
      end
    end
  end
end
