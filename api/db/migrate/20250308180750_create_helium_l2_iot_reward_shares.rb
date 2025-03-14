class CreateHeliumL2IotRewardShares < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_iot_reward_shares, id: false do |t|
      t.string :reward_type
      t.datetime :start_period
      t.datetime :end_period
      t.string :hotspot_key
      t.bigint :beacon_amount
      t.bigint :witness_amount
      t.bigint :dc_transfer_amount
      t.bigint :amount
      t.string :unallocated_reward_type
      t.string :deduplication_key, index: { unique: true }, null: false
    end
  end
end
