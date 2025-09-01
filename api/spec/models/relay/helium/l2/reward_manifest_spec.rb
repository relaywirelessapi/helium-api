# typed: false

RSpec.describe Relay::Helium::L2::RewardManifest do
  it "has a valid factory" do
    expect(build(:helium_l2_reward_manifest)).to be_valid
  end

  it "schedules a reward manifest metadata refresh on creation" do
    expect {
      create(:helium_l2_reward_manifest)
    }.to have_enqueued_job(Relay::Helium::L2::RefreshRewardShareManifestMetadataJob)
  end
end
