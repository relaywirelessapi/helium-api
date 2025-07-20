class AddGinIndexToHotspotsNetworks < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :helium_l2_hotspots, :networks, using: :gin, algorithm: :concurrently
  end
end
