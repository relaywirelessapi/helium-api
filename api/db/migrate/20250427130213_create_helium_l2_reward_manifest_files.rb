class CreateHeliumL2RewardManifestFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_reward_manifest_files, id: false do |t|
      t.uuid :reward_manifest_id, null: false
      t.string :file_name, null: false

      t.foreign_key :helium_l2_reward_manifests,
        column: :reward_manifest_id,
        primary_key: :id,
        on_delete: :cascade,
        null: false,
        index: true

      t.index :file_name
      t.index [ :reward_manifest_id, :file_name ], unique: true
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          INSERT INTO helium_l2_reward_manifest_files (reward_manifest_id, file_name)
          SELECT id, unnest(written_files)
          FROM helium_l2_reward_manifests
          WHERE written_files IS NOT NULL AND array_length(written_files, 1) > 0
        SQL
      end
    end
  end
end
