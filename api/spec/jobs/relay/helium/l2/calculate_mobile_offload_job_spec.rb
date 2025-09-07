# typed: false

RSpec.describe Relay::Helium::L2::CalculateMobileOffloadJob do
  it "schedules the offloaded bytes calculations" do
    mobile_reward_share = create(:helium_l2_mobile_reward_share, dc_transfer_reward: 118844093)
    manifest = create(:helium_l2_reward_manifest, price: 329923000, written_files: [ mobile_reward_share.file_name ])
    reward_manifest_file = create(:helium_l2_reward_manifest_file, reward_manifest: manifest, file_name: mobile_reward_share.file_name)

    described_class.perform_now(reward_manifest_file)

    expect(mobile_reward_share.reload.offloaded_bytes).to eq(773561547)
  end
end
