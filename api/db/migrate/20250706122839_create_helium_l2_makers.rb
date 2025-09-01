class CreateHeliumL2Makers < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_makers, id: :uuid do |t|
      t.string :address, null: false
      t.string :update_authority, null: false
      t.string :issuing_authority, null: false
      t.string :name, null: false
      t.integer :bump_seed, null: false
      t.string :collection, null: false
      t.string :merkle_tree, null: false
      t.integer :collection_bump_seed, null: false
      t.string :dao, null: false

      t.timestamps
    end
  end
end
