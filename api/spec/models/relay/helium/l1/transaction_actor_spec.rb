# typed: false

RSpec.describe Relay::Helium::L1::TransactionActor, type: :model do
  it "is valid with valid attributes" do
    transaction_actor = build_stubbed(:helium_l1_transaction_actor)
    expect(transaction_actor).to be_valid
  end
end
