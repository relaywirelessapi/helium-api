class CreateRelayHeliumL1Files < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l1_files do |t|
      t.string :file_type, null: false
      t.string :file_name, null: false
      t.datetime :processed_at

      t.timestamps

      t.index [ :file_type, :file_name ], unique: true
    end
  end
end
