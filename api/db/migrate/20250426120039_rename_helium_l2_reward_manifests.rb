class RenameHeliumL2RewardManifests < ActiveRecord::Migration[8.0]
  def change
    rename_table :relay_helium_l2_reward_manifests, :helium_l2_reward_manifests
  end
end
