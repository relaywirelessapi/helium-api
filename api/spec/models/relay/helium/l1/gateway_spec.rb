# typed: false

RSpec.describe Relay::Helium::L1::Gateway, type: :model do
  it "is valid with valid attributes" do
    gateway = build_stubbed(:helium_l1_gateway)
    expect(gateway).to be_valid
  end
end
