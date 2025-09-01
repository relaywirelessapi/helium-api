# typed: false

class PlanComponent < ViewComponent::Base
  extend T::Sig

  sig { params(plan: Relay::Billing::Plan, current_user: User).void }
  def initialize(plan:, current_user:)
    @plan = plan
    @current_user = current_user
  end

  private

  sig { returns(Relay::Billing::Plan) }
  attr_reader :plan

  sig { returns(User) }
  attr_reader :current_user

  sig { returns(Relay::Billing::Plan) }
  def current_plan
    current_user.plan
  end

  sig { returns(T::Boolean) }
  def current_plan?
    current_plan.id == plan.id
  end

  sig { returns(Pay::Subscription) }
  def current_subscription
    current_user.payment_processor.subscription
  end
end
