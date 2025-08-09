# typed: false

class User < ApplicationRecord
  extend T::Sig

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  before_create :refresh_api_key
  before_create :set_initial_api_usage_reset_at

  API_USAGE_RESET_INTERVAL = 30.days

  pay_customer default_payment_processor: :stripe

  class << self
    extend T::Sig

    sig { returns(T.nilable(String)) }
    attr_reader :stubbed_plan_id

    sig { params(plan_id: String).void }
    def with_stubbed_plan(plan_id)
      raise "User#with_stubbed_plan can only be called in tests" unless Rails.env.test?

      begin
        @stubbed_plan_id = plan_id
        yield
      ensure
        @stubbed_plan_id = nil
      end
    end
  end

  sig { returns(Relay::Billing::Plan) }
  def plan
    @plan ||= Relay::Billing::Plan.find!(plan_id)
  end

  sig { returns(T.nilable(Integer)) }
  def api_usage_limit
    T.cast(
      plan.find_feature!(Relay::Billing::Features::ApiAccess),
      Relay::Billing::Features::ApiAccess
    ).calls_per_month
  end

  sig { returns(Date) }
  def lookback_window_start_date
    T.cast(
      plan.find_feature!(Relay::Billing::Features::OracleData),
      Relay::Billing::Features::OracleData
    ).lookback_window_start_date
  end

  sig { params(additional_calls: Integer).returns(T::Boolean) }
  def api_usage_limit_exceeded_with?(additional_calls)
    limit = api_usage_limit
    limit ? current_api_usage + additional_calls > limit : false
  end

  sig { params(additional_calls: Integer).void }
  def increment_api_usage_by(additional_calls)
    if Time.zone.now > next_api_usage_reset
      update!(
        current_api_usage: 0,
        api_usage_reset_at: Time.current
      )
    end

    increment!(:current_api_usage, additional_calls)
  end

  sig { returns(Time) }
  def next_api_usage_reset
    api_usage_reset_at + API_USAGE_RESET_INTERVAL
  end

  sig { returns(T::Boolean) }
  def subscription_pending_cancellation?
    subscription = payment_processor.subscription
    return false unless subscription

    payment_processor.subscription.active? && payment_processor.subscription.cancelled?
  end

  sig { returns(Relay::FeatureGater) }
  def feature_gater
    @feature_gater ||= T.let(Relay::FeatureGater.new(self), T.nilable(Relay::FeatureGater))
  end

  private

  sig { void }
  def refresh_api_key
    self.api_key = SecureRandom.hex(32)
  end

  sig { void }
  def refresh_api_key!
    refresh_api_key
    save!
  end

  sig { void }
  def set_initial_api_usage_reset_at
    self.api_usage_reset_at = Time.current
  end

  sig { params(notification: T.untyped, args: T.untyped).void }
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  sig { returns(String) }
  def plan_id
    return self.class.stubbed_plan_id if self.class.stubbed_plan_id

    return "beta" unless feature_gater.enabled?(:billing)

    return "community" unless payment_processor.subscribed?

    payment_processor.subscription.object.fetch("items").fetch("data").first.fetch("price").fetch("lookup_key").split("-").first
  end
end
