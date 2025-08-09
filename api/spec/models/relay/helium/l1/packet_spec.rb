# typed: false

RSpec.describe Relay::Helium::L1::Packet, type: :model do
  it "is valid with valid attributes" do
    packet = build_stubbed(:helium_l1_packet)
    expect(packet).to be_valid
  end
end
