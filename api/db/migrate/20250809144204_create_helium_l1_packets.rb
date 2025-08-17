class CreateHeliumL1Packets < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        create_table :helium_l1_packets, id: :uuid do |t|
          t.bigint :block, null: false
          t.string :transaction_hash, null: false
          t.bigint :time, null: false
          t.string :gateway_address, null: false
          t.integer :num_packets, null: false
          t.integer :num_dcs, null: false

          t.timestamps
        end

        add_index :helium_l1_packets, :block
        add_index :helium_l1_packets, :transaction_hash
        add_index :helium_l1_packets, :gateway_address
        add_index :helium_l1_packets, :time
      end

      dir.down do
        drop_table :helium_l1_packets
      end
    end
  end
end
