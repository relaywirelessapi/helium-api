class CreateHeliumL1Gateways < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        create_table :helium_l1_gateways, id: :uuid do |t|
          t.string :address, null: false
          t.string :owner_address, null: false
          t.string :location
          t.bigint :last_poc_challenge
          t.string :last_poc_onion_key_hash
          t.jsonb :witnesses, default: {}
          t.bigint :first_block, null: false
          t.bigint :last_block, null: false
          t.integer :nonce, null: false, default: 0
          t.string :name, null: false
          t.datetime :first_timestamp, null: false
          t.decimal :reward_scale, precision: 10, scale: 2
          t.integer :elevation, null: false, default: 0
          t.integer :gain, null: false, default: 12
          t.string :location_hex
          t.string :mode, null: false, default: 'full'
          t.string :payer_address, null: false

          t.timestamps
        end

        add_index :helium_l1_gateways, :address, unique: true
        add_index :helium_l1_gateways, :owner_address
        add_index :helium_l1_gateways, :payer_address
        add_index :helium_l1_gateways, :first_block
        add_index :helium_l1_gateways, :last_block
        add_index :helium_l1_gateways, :name
        add_index :helium_l1_gateways, :mode
      end

      dir.down do
        drop_table :helium_l1_gateways
      end
    end
  end
end
