class CreateHeliumL1DcBurns < ActiveRecord::Migration[8.0]
  def up
    create_table :helium_l1_dc_burns, id: :uuid do |t|
      t.bigint :block, null: false
      t.string :transaction_hash, null: false
      t.string :actor_address, null: false
      t.string :type, null: false
      t.bigint :amount, null: false
      t.bigint :oracle_price, null: false
      t.bigint :time, null: false

      t.timestamps
    end

    add_index :helium_l1_dc_burns, :block
    add_index :helium_l1_dc_burns, :transaction_hash
    add_index :helium_l1_dc_burns, :actor_address
    add_index :helium_l1_dc_burns, :type
    add_index :helium_l1_dc_burns, :time
  end

  def down
    drop_table :helium_l1_dc_burns
  end
end
