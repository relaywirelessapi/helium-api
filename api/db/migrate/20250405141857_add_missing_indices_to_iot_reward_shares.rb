class AddMissingIndicesToIotRewardShares < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :helium_l2_iot_reward_shares, [:start_period, :end_period], algorithm: :concurrently
    add_index :helium_l2_iot_reward_shares, :hotspot_key, algorithm: :concurrently
    add_index :helium_l2_iot_reward_shares, :reward_type, algorithm: :concurrently
    remove_index :helium_l2_iot_reward_shares, :start_period, algorithm: :concurrently
  end
end
