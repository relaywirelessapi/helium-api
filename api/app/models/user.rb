# typed: false

class User < ApplicationRecord
  extend T::Sig

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  before_create :refresh_api_key
  before_create :set_initial_api_usage_reset_at

  API_USAGE_RESET_INTERVAL = 30.days

  sig { returns(Integer) }
  def api_usage_limit
    10_000
  end

  sig { params(complexity: Integer).returns(T::Boolean) }
  def api_usage_limit_exceeded_with?(complexity)
    current_api_usage + complexity > api_usage_limit
  end

  sig { params(complexity: Integer).void }
  def increment_api_usage_by(complexity)
    if api_usage_reset_at <= API_USAGE_RESET_INTERVAL.ago
      update!(
        current_api_usage: 0,
        api_usage_reset_at: Time.current
      )
    end

    increment!(:current_api_usage, complexity)
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
    devise_mailer.send(notification, self, *args).deliver_now
  end
end
