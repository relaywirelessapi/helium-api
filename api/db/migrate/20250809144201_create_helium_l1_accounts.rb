class CreateHeliumL1Accounts < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        create_table :helium_l1_accounts, id: :uuid do |t|
          t.string :address, null: false
          t.bigint :balance, null: false, default: 0
          t.integer :nonce, null: false, default: 0
          t.bigint :dc_balance, null: false, default: 0
          t.integer :dc_nonce, null: false, default: 0
          t.bigint :security_balance, null: false, default: 0
          t.integer :security_nonce, null: false, default: 0
          t.bigint :first_block, null: false
          t.bigint :last_block, null: false
          t.bigint :staked_balance, null: false, default: 0
          t.bigint :mobile_balance, null: false, default: 0
          t.bigint :iot_balance, null: false, default: 0

          t.timestamps
        end

        add_index :helium_l1_accounts, :address, unique: true
        add_index :helium_l1_accounts, :first_block
        add_index :helium_l1_accounts, :last_block
      end

      dir.down do
        drop_table :helium_l1_accounts
      end
    end
  end
end
