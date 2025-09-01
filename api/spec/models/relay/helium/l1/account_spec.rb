# typed: false

RSpec.describe Relay::Helium::L1::Account, type: :model do
  it "is valid with valid attributes" do
    account = build_stubbed(:helium_l1_account)
    expect(account).to be_valid
  end
end
