class ConvertMobileRewardSharesOffloadedBytesToBigint < ActiveRecord::Migration[8.0]
  def change
    change_column :helium_l2_mobile_reward_shares, :offloaded_bytes, :bigint
  end
end
