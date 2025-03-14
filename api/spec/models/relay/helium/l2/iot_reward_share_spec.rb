# typed: false

RSpec.describe Relay::Helium::L2::IotRewardShare do
  it "has a valid factory" do
    expect(build(:helium_l2_iot_reward_share)).to be_valid
  end
end
