# typed: false

RSpec.describe Relay::Helium::L1::Transaction, type: :model do
  it "is valid with valid attributes" do
    transaction = build_stubbed(:helium_l1_transaction)
    expect(transaction).to be_valid
  end
end
