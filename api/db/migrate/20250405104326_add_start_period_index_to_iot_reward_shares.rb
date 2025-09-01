class AddStartPeriodIndexToIotRewardShares < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :helium_l2_iot_reward_shares, :start_period, algorithm: :concurrently
  end
end
