class SplitFilePrefixAndNameInOracleFiles < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        add_column :helium_l2_files, :category, :string
        add_column :helium_l2_files, :name, :string

        execute "UPDATE helium_l2_files SET category = split_part(s3_key, '/', 1)"
        execute "UPDATE helium_l2_files SET name = split_part(s3_key, '/', 2)"

        change_column_null :helium_l2_files, :category, false
        change_column_null :helium_l2_files, :name, false

        add_index :helium_l2_files, :category
        add_index :helium_l2_files, :name
        add_index :helium_l2_files, [ :category, :name ], unique: true

        remove_column :helium_l2_files, :s3_key
      end

      dir.down do
        add_column :helium_l2_files, :s3_key, :string

        execute "UPDATE helium_l2_files SET s3_key = CONCAT(category, '/', name)"

        change_column_null :helium_l2_files, :s3_key, false

        add_index :helium_l2_files, :s3_key, unique: true

        remove_column :helium_l2_files, :name
        remove_column :helium_l2_files, :category
      end
    end
  end
end
