# typed: false

class User < ApplicationRecord
  extend T::Sig

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  before_create :refresh_api_key
  before_create :set_initial_api_usage_reset_at

  API_USAGE_RESET_INTERVAL = 30.days

  sig { returns(String) }
  def plan_id
    "beta"
  end

  sig { returns(Relay::Billing::Plan) }
  def plan
    @plan ||= Relay::Billing::Plan.find!(plan_id)
  end

  sig { returns(T.nilable(Integer)) }
  def api_usage_limit
    T.cast(plan.find_feature!(Relay::Billing::Features::ApiAccess), Relay::Billing::Features::ApiAccess).calls_per_month
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
end
