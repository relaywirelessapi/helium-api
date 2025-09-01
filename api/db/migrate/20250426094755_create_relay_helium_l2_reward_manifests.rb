class CreateRelayHeliumL2RewardManifests < ActiveRecord::Migration[8.0]
  def change
    create_table :relay_helium_l2_reward_manifests, id: false do |t|
      t.string :written_files, array: true
      t.datetime :start_timestamp, index: true
      t.datetime :end_timestamp, index: true
      t.jsonb :reward_data
      t.bigint :epoch
      t.bigint :price
      t.string :deduplication_key, index: { unique: true }, null: false
    end
  end
end
