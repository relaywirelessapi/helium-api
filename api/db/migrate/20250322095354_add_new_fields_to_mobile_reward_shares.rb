class AddNewFieldsToMobileRewardShares < ActiveRecord::Migration[8.0]
  def change
    add_column :helium_l2_mobile_reward_shares, :base_coverage_points_sum, :decimal, precision: 20, scale: 8
    add_column :helium_l2_mobile_reward_shares, :boosted_coverage_points_sum, :decimal, precision: 20, scale: 8
    add_column :helium_l2_mobile_reward_shares, :base_reward_shares, :decimal, precision: 20, scale: 8
    add_column :helium_l2_mobile_reward_shares, :boosted_reward_shares, :decimal, precision: 20, scale: 8
    add_column :helium_l2_mobile_reward_shares, :base_poc_reward, :bigint
    add_column :helium_l2_mobile_reward_shares, :boosted_poc_reward, :bigint
    add_column :helium_l2_mobile_reward_shares, :seniority_timestamp, :bigint
    add_column :helium_l2_mobile_reward_shares, :coverage_object, :binary
    add_column :helium_l2_mobile_reward_shares, :location_trust_score_multiplier, :decimal, precision: 20, scale: 8
    add_column :helium_l2_mobile_reward_shares, :speedtest_multiplier, :decimal, precision: 20, scale: 8
    add_column :helium_l2_mobile_reward_shares, :sp_boosted_hex_status, :integer
    add_column :helium_l2_mobile_reward_shares, :oracle_boosted_hex_status, :integer
    add_column :helium_l2_mobile_reward_shares, :entity, :string
    add_column :helium_l2_mobile_reward_shares, :service_provider_amount, :bigint
    add_column :helium_l2_mobile_reward_shares, :matched_amount, :bigint
  end
end
