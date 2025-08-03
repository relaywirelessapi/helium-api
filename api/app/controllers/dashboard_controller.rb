# typed: false

class DashboardController < ApplicationController
  extend T::Sig

  before_action :authenticate_user!

  sig { void }
  def show
  end

  sig { void }
  def subscribe
    plan = Relay::Billing::Plan.find!(params.fetch(:plan_id))

    if plan.custom_pricing?
      redirect_back(fallback_location: root_url)
      return
    end

    if plan.free?
      unless current_user.payment_processor.subscribed?
        redirect_back(fallback_location: root_url)
        return
      end

      current_user.payment_processor.subscription.cancel
      redirect_back(fallback_location: root_url)

      return
    end

    if current_user.payment_processor.subscribed?
      current_user.payment_processor.subscription.swap(plan.stripe_price.id)
      redirect_to root_url
    else
      session = current_user.payment_processor.checkout(
        mode: "subscription",
        line_items: [ {
          price: plan.stripe_price.id,
          quantity: 1
        } ],
        payment_method_collection: "if_required",
        success_url: root_url,
        cancel_url: root_url
      )

      redirect_to session.url, allow_other_host: true
    end
  end

  sig { void }
  def billing_portal
    portal_session = current_user.payment_processor.billing_portal

    redirect_to portal_session.url, allow_other_host: true
  end
end
