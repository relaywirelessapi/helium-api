# typed: false

RSpec.describe Relay::Helium::L2::RewardManifestFile do
  it "schedules the mobile offload calculation on creation" do
    reward_manifest_file = build(:helium_l2_reward_manifest_file)

    expect {
      reward_manifest_file.save!
    }.to have_enqueued_job(Relay::Helium::L2::ScheduleMobileOffloadCalculationsJob).with(reward_manifest_file)
  end
end
