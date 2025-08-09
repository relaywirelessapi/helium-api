class AddLocationIndicesToHotspots < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :helium_l2_hotspots, :iot_location, algorithm: :concurrently
    add_index :helium_l2_hotspots, :mobile_location, algorithm: :concurrently
  end
end
