# typed: strict
# frozen_string_literal: true

class PlanDetailsComponent < ViewComponent::Base
  extend T::Sig

  sig { params(plan: Relay::Plan).void }
  def initialize(plan:)
    @plan = plan
  end

  private

  sig { returns(Relay::Plan) }
  attr_reader :plan

  sig { returns(T.nilable(String)) }
  def plan_name
    plan.name
  end

  sig { returns(T.nilable(String)) }
  def plan_description
    plan.description
  end

  sig { returns(T::Array[String]) }
  def features
    plan.features
  end
end
