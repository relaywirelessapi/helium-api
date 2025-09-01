class UseNumericForHeliumL2RewardAmounts < ActiveRecord::Migration[8.0]
  def change
    change_column :helium_l2_mobile_reward_shares, :amount, :decimal, precision: 20, scale: 0
    change_column :helium_l2_mobile_reward_shares, :dc_transfer_reward, :decimal, precision: 20, scale: 0
    change_column :helium_l2_mobile_reward_shares, :poc_reward, :decimal, precision: 20, scale: 0
    change_column :helium_l2_mobile_reward_shares, :subscriber_reward, :decimal, precision: 20, scale: 0
    change_column :helium_l2_mobile_reward_shares, :discovery_location_amount, :decimal, precision: 20, scale: 0
    change_column :helium_l2_mobile_reward_shares, :service_provider_amount, :decimal, precision: 20, scale: 0
    change_column :helium_l2_mobile_reward_shares, :matched_amount, :decimal, precision: 20, scale: 0

    change_column :helium_l2_iot_reward_shares, :beacon_amount, :decimal, precision: 20, scale: 0
    change_column :helium_l2_iot_reward_shares, :witness_amount, :decimal, precision: 20, scale: 0
    change_column :helium_l2_iot_reward_shares, :dc_transfer_amount, :decimal, precision: 20, scale: 0
    change_column :helium_l2_iot_reward_shares, :amount, :decimal, precision: 20, scale: 0
  end
end
