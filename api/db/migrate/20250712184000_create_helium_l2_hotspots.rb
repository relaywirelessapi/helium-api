class CreateHeliumL2Hotspots < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_hotspots, id: :uuid do |t|
      t.string :asset_id, null: false
      t.string :ecc_key, null: false
      t.string :owner, null: false
      t.string :networks, array: true, null: false
      t.string :name, null: false
      t.uuid :maker_id, null: false

      # IOT-specific fields
      t.string :iot_info_address, null: true
      t.integer :iot_bump_seed, null: true
      t.bigint :iot_location, null: true
      t.integer :iot_elevation, null: true
      t.integer :iot_gain, null: true
      t.boolean :iot_is_full_hotspot, null: true
      t.integer :iot_num_location_asserts, null: true
      t.boolean :iot_is_active, null: true
      t.integer :iot_dc_onboarding_fee_paid, null: true

      # MOBILE-specific fields
      t.string :mobile_info_address, null: true
      t.integer :mobile_bump_seed, null: true
      t.bigint :mobile_location, null: true
      t.boolean :mobile_is_full_hotspot, null: true
      t.integer :mobile_num_location_asserts, null: true
      t.boolean :mobile_is_active, null: true
      t.integer :mobile_dc_onboarding_fee_paid, null: true
      t.string :mobile_device_type, null: true

      # MOBILE-specific deployment info fields (WiFi only)
      t.integer :mobile_antenna, null: true
      t.integer :mobile_azimuth, null: true
      t.integer :mobile_mechanical_down_tilt, null: true
      t.integer :mobile_electrical_down_tilt, null: true

      t.timestamps

      t.index :iot_info_address, unique: true
      t.index :mobile_info_address, unique: true
      t.index :owner
      t.index :asset_id, unique: true
      t.index :ecc_key, unique: true

      t.foreign_key :helium_l2_makers, column: :maker_id, primary_key: :id
    end
  end
end
