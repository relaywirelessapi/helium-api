# typed: strict

module Relay
  module Helium
    module L2
      class CalculateMobileOffloadJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { params(mobile_reward_share: Relay::Helium::L2::MobileRewardShare).void }
        def perform(mobile_reward_share)
          mobile_reward_share.refresh_offloaded_bytes!
        end
      end
    end
  end
end
