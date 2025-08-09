class CreateHeliumL1Rewards < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        create_table :helium_l1_rewards, id: :uuid do |t|
          t.bigint :block, null: false
          t.string :transaction_hash, null: false
          t.bigint :time, null: false
          t.string :account_address, null: false
          t.string :gateway_address, null: false
          t.bigint :amount, null: false
          t.string :type, null: false

          t.timestamps
        end

        add_index :helium_l1_rewards, :block
        add_index :helium_l1_rewards, :transaction_hash
        add_index :helium_l1_rewards, :account_address
        add_index :helium_l1_rewards, :gateway_address
        add_index :helium_l1_rewards, :type
        add_index :helium_l1_rewards, :time
      end

      dir.down do
        drop_table :helium_l1_rewards
      end
    end
  end
end
