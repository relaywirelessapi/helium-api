class RemoveIdFromOracleFiles < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        remove_column :helium_l2_files, :id
      end

      dir.down do
        add_column :helium_l2_files, :id, :bigint
      end
    end
  end
end
