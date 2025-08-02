# typed: strict
# frozen_string_literal: true

class PlanUsageComponent < ViewComponent::Base
  extend T::Sig

  sig { params(user: User).void }
  def initialize(user:)
    @user = user
  end

  private

  sig { returns(User) }
  attr_reader :user

  sig { returns(Integer) }
  def api_calls
    user.current_api_usage
  end

  sig { returns(T.nilable(Integer)) }
  def api_calls_limit
    user.api_usage_limit
  end

  sig { returns(ActiveSupport::TimeWithZone) }
  def historical_data_from
    user.api_usage_reset_at
  end
end
