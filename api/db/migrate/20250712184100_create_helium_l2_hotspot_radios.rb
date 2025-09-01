class CreateHeliumL2HotspotRadios < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_hotspot_radios, id: :uuid do |t|
      t.uuid :hotspot_id, null: false
      t.string :radio_id, null: false
      t.integer :elevation, null: false

      t.foreign_key :helium_l2_hotspots, column: :hotspot_id, primary_key: :id, on_delete: :cascade
    end
  end
end
