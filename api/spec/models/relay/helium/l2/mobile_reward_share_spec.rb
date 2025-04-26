# typed: false

RSpec.describe Relay::Helium::L2::RewardManifest do
  it "has a valid factory" do
    expect(build(:helium_l2_reward_manifest)).to be_valid
  end
end
