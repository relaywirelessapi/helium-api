# typed: strict

module Relay
  module Helium
    module L2
      class MobileRewardShare < ApplicationRecord
        include OracleData

        self.table_name = "helium_l2_mobile_reward_shares"
      end
    end
  end
end
