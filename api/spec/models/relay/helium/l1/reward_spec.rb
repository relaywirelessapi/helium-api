# typed: false

RSpec.describe Relay::Helium::L1::Reward, type: :model do
  it "is valid with valid attributes" do
    reward = build_stubbed(:helium_l1_reward)
    expect(reward).to be_valid
  end
end
