# typed: false

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build_stubbed(:user)
    expect(user).to be_valid
  end

  it "enqueues payment processor user creation" do
    user = build(:user)

    expect {
      user.save!
    }.to have_enqueued_job(Relay::Billing::CreatePaymentProcessorUserJob).with(user)
  end

  describe "#plan" do
    context "when in production" do
      it "always returns the Beta plan" do
        allow(Rails.env).to receive(:production?).and_return(true)
        user = create_user_with_payment_processor(plan_id: "professional")

        plan = user.plan

        expect(plan.id).to eq("beta")
      end
    end

    context "when in development" do
      context "when the user is not subscribed" do
        it "returns the Community plan" do
          allow(Rails.env).to receive(:production?).and_return(false)
          user = create_user_with_payment_processor(plan_id: nil)

          plan = user.plan

          expect(plan.id).to eq("community")
        end
      end

      context "when the user is subscribed" do
        it "returns the plan associated with the subscription" do
          allow(Rails.env).to receive(:production?).and_return(false)
          user = create_user_with_payment_processor(plan_id: "starter")

          plan = user.plan

          expect(plan.id).to eq("starter")
        end
      end
    end
  end

  describe "#api_usage_limit" do
    it "returns the API usage limit for the user's plan" do
      user = create_user_with_payment_processor(plan_id: "starter")

      expect(user.api_usage_limit).to eq(105_000)
    end
  end

  describe "#api_usage_limit_exceeded_with?" do
    it "returns true if the usage limit will be exceeded" do
      user = user = create_user_with_payment_processor(plan_id: "starter", current_api_usage: 105_000)

      expect(user.api_usage_limit_exceeded_with?(1)).to be_truthy
    end

    it "returns false if the usage limit will not be exceeded" do
      user = create_user_with_payment_processor(plan_id: "starter", current_api_usage: 104_999)

      expect(user.api_usage_limit_exceeded_with?(1)).to be_falsey
    end
  end

  describe "#increment_api_usage_by" do
    it "increments the usage limit by the given amount" do
      user = create_user_with_payment_processor(plan_id: "starter", current_api_usage: 0)

      user.increment_api_usage_by(1)

      expect(user.current_api_usage).to eq(1)
    end

    it "resets usage when past the reset time" do
      freeze_time do
        user = create_user_with_payment_processor(plan_id: "starter", current_api_usage: 5000)
        user.update!(api_usage_reset_at: 31.days.ago)

        user.increment_api_usage_by(100)

        expect(user).to have_attributes(
          current_api_usage: 100,
          api_usage_reset_at: Time.current
        )
      end
    end

    it "does not reset usage when before the reset time" do
      freeze_time do
        user = create_user_with_payment_processor(plan_id: "starter", current_api_usage: 5000)
        user.update!(api_usage_reset_at: 29.days.ago)

        user.increment_api_usage_by(100)

        expect(user).to have_attributes(
          current_api_usage: 5100,
          api_usage_reset_at: 29.days.ago
        )
      end
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

  private

  define_method(:create_user_with_payment_processor) do |plan_id: nil, **attributes|
    user = create(:user, **attributes)
    user.set_payment_processor(:fake_processor, allow_fake: true)

    if plan_id
      user.payment_processor.subscribe.tap do |subscription|
        subscription.update!(object: { items: { data: [ { price: { lookup_key: "#{plan_id}-monthly" } } ] } })
      end
    end

    user
  end
end
