class CreateHeliumL1TransactionActors < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        create_table :helium_l1_transaction_actors, id: :uuid do |t|
          t.string :actor_address, null: false
          t.string :actor_role, null: false
          t.string :transaction_hash, null: false
          t.bigint :block, null: false

          t.timestamps
        end

        add_index :helium_l1_transaction_actors, :actor_address
        add_index :helium_l1_transaction_actors, :actor_role
        add_index :helium_l1_transaction_actors, :transaction_hash
        add_index :helium_l1_transaction_actors, :block
        add_index :helium_l1_transaction_actors, [ :transaction_hash, :actor_address ], unique: true
      end

      dir.down do
        drop_table :helium_l1_transaction_actors
      end
    end
  end
end
