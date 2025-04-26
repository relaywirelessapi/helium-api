class AddIndexOnRewardManifestWrittenFiles < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :helium_l2_reward_manifests, :written_files, using: :gin, algorithm: :concurrently
  end
end
