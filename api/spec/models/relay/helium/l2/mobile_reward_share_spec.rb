# typed: false

RSpec.describe Relay::Helium::L2::MobileRewardShare do
  it "has a valid factory" do
    expect(build(:helium_l2_mobile_reward_share)).to be_valid
  end

  describe "#refresh_offloaded_bytes" do
    it "computes offloaded bytes" do
      reward_manifest = create(:helium_l2_reward_manifest, price: 329923000)
      reward_manifest_file = create(:helium_l2_reward_manifest_file, reward_manifest: reward_manifest)
      mobile_reward_share = build(
        :helium_l2_mobile_reward_share,
        dc_transfer_reward: 118844093,
        file_name: reward_manifest_file.file_name
      )

      mobile_reward_share.refresh_offloaded_bytes

      # 118844093 bones / 329923000 bones per dollar / 0.50 dollars per GB x 1024^3
      expect(mobile_reward_share.offloaded_bytes).to eq(773561547)
    end
  end
end
