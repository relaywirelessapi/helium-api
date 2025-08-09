class RemoveUnusedIndicesOnHeliumL2Hotspots < ActiveRecord::Migration[8.0]
  def change
    if index_exists?(:helium_l2_hotspots, :iot_info_address, unique: true)
      remove_index :helium_l2_hotspots, :iot_info_address, unique: true
    end

    if index_exists?(:helium_l2_hotspots, :mobile_info_address, unique: true)
      remove_index :helium_l2_hotspots, :mobile_info_address, unique: true
    end
  end
end
