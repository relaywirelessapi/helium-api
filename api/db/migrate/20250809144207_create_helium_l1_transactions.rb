class CreateHeliumL1Transactions < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        create_table :helium_l1_transactions, id: :uuid do |t|
          t.bigint :block, null: false
          t.string :transaction_hash, null: false
          t.string :type, null: false
          t.jsonb :fields, null: false, default: {}
          t.bigint :time, null: false

          t.timestamps
        end

        add_index :helium_l1_transactions, :block
        add_index :helium_l1_transactions, :transaction_hash, unique: true
        add_index :helium_l1_transactions, :type
        add_index :helium_l1_transactions, :time
      end

      dir.down do
        drop_table :helium_l1_transactions
      end
    end
  end
end
