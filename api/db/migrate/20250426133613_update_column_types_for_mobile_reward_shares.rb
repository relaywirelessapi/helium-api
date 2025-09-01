class UpdateColumnTypesForMobileRewardShares < ActiveRecord::Migration[8.0]
  def change
    remove_column :helium_l2_mobile_reward_shares, :seniority_timestamp, :bigint
    add_column :helium_l2_mobile_reward_shares, :seniority_timestamp, :datetime
    change_column :helium_l2_mobile_reward_shares, :sp_boosted_hex_status, :string
    change_column :helium_l2_mobile_reward_shares, :oracle_boosted_hex_status, :string
  end
end
