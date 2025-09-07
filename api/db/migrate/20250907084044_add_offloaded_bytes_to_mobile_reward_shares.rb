class AddOffloadedBytesToMobileRewardShares < ActiveRecord::Migration[8.0]
  def change
    add_column :helium_l2_mobile_reward_shares, :offloaded_bytes, :integer
  end
end
