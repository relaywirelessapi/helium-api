# typed: false

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build_stubbed(:user)
    expect(user).to be_valid
  end

  describe "#api_usage_limit" do
    it "returns 10_000" do
      expect(build_stubbed(:user).api_usage_limit).to eq(10_000)
    end
  end

  describe "#api_usage_limit_exceeded_with?" do
    it "returns true if the usage limit will be exceeded" do
      user = build_stubbed(:user, current_api_usage: 10_000)

      expect(user.api_usage_limit_exceeded_with?(1)).to be_truthy
    end

    it "returns false if the usage limit will not be exceeded" do
      user = build_stubbed(:user, current_api_usage: 9_999)

      expect(user.api_usage_limit_exceeded_with?(1)).to be_falsey
    end
  end

  describe "#increment_api_usage_by" do
    it "increments the usage limit by the given amount" do
      user = create(:user, current_api_usage: 0)

      user.increment_api_usage_by(1)

      expect(user.current_api_usage).to eq(1)
    end
  end

  describe "#next_api_usage_reset" do
    it "returns the next usage reset time" do
      freeze_time do
        user = build_stubbed(:user, api_usage_reset_at: Time.current)

        expect(user.next_api_usage_reset).to eq(30.days.from_now)
      end
    end
  end
end
