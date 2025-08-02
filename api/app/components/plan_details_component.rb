# typed: strict

class PlanDetailsComponent < ViewComponent::Base
  extend T::Sig

  sig { params(plan: Relay::Billing::Plan).void }
  def initialize(plan:)
    @plan = plan
  end

  private

  sig { returns(Relay::Billing::Plan) }
  attr_reader :plan

  sig { returns(T.nilable(String)) }
  def formatted_price
    return "Contact us" if plan.price_per_month.nil?
    return "Free" if plan.price_per_month == 0.00

    "$#{plan.price_per_month}/month"
  end
end
