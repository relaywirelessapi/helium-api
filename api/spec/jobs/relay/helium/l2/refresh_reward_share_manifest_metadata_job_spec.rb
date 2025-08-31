# typed: false

RSpec.describe Relay::Helium::L2::RefreshRewardShareManifestMetadataJob do
  it "updates the reward manifest metadata for all reward shares" do
    file1 = create(:helium_l2_file)
    file2 = create(:helium_l2_file)
    reward_manifest = create(:helium_l2_reward_manifest)
    create(:helium_l2_reward_manifest_file, reward_manifest:, file_name: file1.name)
    create(:helium_l2_reward_manifest_file, reward_manifest:, file_name: file2.name)
    iot_reward_share = create(:helium_l2_iot_reward_share, file_name: file1.name)
    mobile_reward_share = create(:helium_l2_mobile_reward_share, file_name: file2.name)

    described_class.perform_now(reward_manifest)

    aggregate_failures do
      expect(iot_reward_share.reload.reward_manifest_metadata).to eq(reward_manifest.metadata.as_json)
      expect(mobile_reward_share.reload.reward_manifest_metadata).to eq(reward_manifest.metadata.as_json)
    end
  end
end
