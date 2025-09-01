class CreateAddRewardManifestMetadataToRewardShares < ActiveRecord::Migration[8.0]
  def change
    add_column :helium_l2_iot_reward_shares, :reward_manifest_metadata, :jsonb
    add_column :helium_l2_mobile_reward_shares, :reward_manifest_metadata, :jsonb
  end
end
