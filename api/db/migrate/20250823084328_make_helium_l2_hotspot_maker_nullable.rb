class MakeHeliumL2HotspotMakerNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :helium_l2_hotspots, :maker_id, true
  end
end
