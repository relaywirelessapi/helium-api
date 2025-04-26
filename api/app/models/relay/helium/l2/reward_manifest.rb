# typed: strict

module Relay
  module Helium
    module L2
      class RewardManifest < ApplicationRecord
        self.table_name = "relay_helium_l2_reward_manifests"
      end
    end
  end
end
