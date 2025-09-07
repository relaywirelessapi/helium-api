# typed: false

RSpec.describe Relay::Helium::L2::CalculateMobileOffloadJob do
  it "calculates the offloaded bytes" do
    mobile_reward_share = instance_spy(Relay::Helium::L2::MobileRewardShare)

    described_class.perform_now(mobile_reward_share)

    expect(mobile_reward_share).to have_received(:refresh_offloaded_bytes!)
  end
end
