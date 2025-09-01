# typed: false

RSpec.describe Relay::Helium::L1::DcBurn, type: :model do
  it "is valid with valid attributes" do
    dc_burn = build_stubbed(:helium_l1_dc_burn)
    expect(dc_burn).to be_valid
  end
end
