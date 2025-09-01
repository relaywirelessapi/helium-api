class CreateHeliumL2Files < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_files do |t|
      t.string :definition_id, null: false
      t.string :s3_key, null: false, index: { unique: true }
      t.datetime :started_at
      t.datetime :completed_at
      t.bigint :position, null: false, default: 0

      t.timestamps
    end
  end
end
