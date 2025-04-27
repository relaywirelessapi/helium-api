class AddGranularTimestampsToHeliumL2Files < ActiveRecord::Migration[8.0]
  def change
    add_column :helium_l2_files, :download_started_at, :datetime
    add_column :helium_l2_files, :download_completed_at, :datetime
    add_column :helium_l2_files, :import_started_at, :datetime
    add_column :helium_l2_files, :import_completed_at, :datetime
  end
end
