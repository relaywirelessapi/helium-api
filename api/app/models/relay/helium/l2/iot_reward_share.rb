# typed: strict

module Relay
  module Helium
    module L2
      class IotRewardShare < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l2_iot_reward_shares"
      end
    end
  end
end
