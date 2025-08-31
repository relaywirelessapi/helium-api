# typed: false

RSpec.describe Relay::Helium::L2::MobileRewardShare do
  it "has a valid factory" do
    expect(build(:helium_l2_mobile_reward_share)).to be_valid
  end
end
