# typed: false

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build_stubbed(:user)
    expect(user).to be_valid
  end
end
