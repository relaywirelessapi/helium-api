class CreateRelayHeliumL2MobileRewardShares < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_mobile_reward_shares, id: false do |t|
      t.string :owner_key
      t.string :hotspot_key
      t.string :cbsd_id
      t.bigint :amount
      t.datetime :start_period
      t.datetime :end_period
      t.string :reward_type
      t.bigint :dc_transfer_reward
      t.bigint :poc_reward
      t.string :subscriber_id
      t.bigint :subscriber_reward
      t.bigint :discovery_location_amount
      t.string :unallocated_reward_type
      t.string :service_provider_id
      t.string :deduplication_key, index: { unique: true }, null: false
      t.timestamps
    end
  end
end
