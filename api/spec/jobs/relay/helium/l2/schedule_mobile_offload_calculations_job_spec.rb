# typed: false

RSpec.describe Relay::Helium::L2::ScheduleMobileOffloadCalculationsJob do
  it "schedules the offloaded bytes calculations" do
    file = create(:helium_l2_file)
    reward_manifest_file = create(:helium_l2_reward_manifest_file, file_name: file.name)
    mobile_reward_share = create(:helium_l2_mobile_reward_share, dc_transfer_reward: 1000000, offloaded_bytes: nil, file: file)
    create(:helium_l2_mobile_reward_share, dc_transfer_reward: nil, offloaded_bytes: nil, file: file)
    create(:helium_l2_mobile_reward_share, dc_transfer_reward: 1000000, offloaded_bytes: 1000000, file: file)
    create(:helium_l2_mobile_reward_share, dc_transfer_reward: 1000000, offloaded_bytes: nil)

    expect {
      described_class.perform_now(reward_manifest_file)
    }.to have_enqueued_job(Relay::Helium::L2::CalculateMobileOffloadJob).with(mobile_reward_share)
  end
end
