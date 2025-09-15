# typed: strict

namespace :billing do
  namespace :stripe do
    desc "Sync all configured plans with Stripe (create individual products for each plan)"
    task setup_plans: :environment do
      puts "Starting Stripe plan sync..."

      plans = Relay::Billing::Plan.all
      puts "Found #{plans.length} plans to sync"

      plans.each do |plan|
        sync_plan_with_stripe(plan)
      end

      puts "\nStripe plan sync completed!"
    end

    desc "Configure Stripe webhooks with proper endpoint URL and events"
    task setup_webhooks: :environment do
      domain_name = ENV["DOMAIN_NAME"]

      if domain_name.nil? || domain_name.empty?
        puts "❌ Error: DOMAIN_NAME environment variable is not set"
        puts "Please set DOMAIN_NAME to your domain (e.g., 'example.com')"
        exit 1
      end

      webhook_url = "https://#{domain_name}/pay/webhooks/stripe"

      puts "Configuring Stripe webhooks..."
      puts "Domain: #{domain_name}"
      puts "Webhook URL: #{webhook_url}"
      puts ""

      # Required events for Pay gem
      required_events = [
        "charge.succeeded",
        "charge.refunded",
        "charge.updated",
        "payment_intent.succeeded",
        "invoice.upcoming",
        "invoice.payment_action_required",
        "invoice.payment_failed",
        "customer.subscription.created",
        "customer.subscription.updated",
        "customer.subscription.deleted",
        "customer.subscription.trial_will_end",
        "customer.updated",
        "customer.deleted",
        "payment_method.attached",
        "payment_method.updated",
        "payment_method.automatically_updated",
        "payment_method.detached",
        "account.updated",
        "checkout.session.completed",
        "checkout.session.async_payment_succeeded"
      ]

      puts "Required webhook events:"
      required_events.each { |event| puts "  • #{event}" }
      puts ""

      # Check if webhook already exists
      existing_webhooks = Stripe::WebhookEndpoint.list
      existing_webhook = existing_webhooks.data.find { |webhook| webhook.url == webhook_url }

      if existing_webhook
        puts "Found existing webhook endpoint: #{existing_webhook.id}"
        puts "URL: #{existing_webhook.url}"
        puts "Status: #{existing_webhook.status}"
        puts ""

        # Check if it has all required events
        missing_events = required_events - existing_webhook.enabled_events
        if missing_events.empty?
          puts "✅ Webhook is already configured with all required events!"
          puts "Signing secret: #{existing_webhook.secret}"
        else
          puts "⚠️  Webhook exists but is missing some required events:"
          missing_events.each { |event| puts "  • #{event}" }
          puts ""
          puts "To update the webhook, please visit the Stripe Dashboard:"
          puts "https://dashboard.stripe.com/webhooks/#{existing_webhook.id}"
        end
      else
        puts "Creating new webhook endpoint..."

        begin
          webhook = Stripe::WebhookEndpoint.create(
            url: webhook_url,
            enabled_events: required_events,
            description: "Relay API Pay webhooks"
          )

          puts "✅ Successfully created webhook endpoint!"
          puts "Webhook ID: #{webhook.id}"
          puts "URL: #{webhook.url}"
          puts "Status: #{webhook.status}"
          puts "Signing secret: #{webhook.secret}"
          puts ""
          puts "⚠️  IMPORTANT: Add the signing secret to your environment variables:"
          puts "STRIPE_SIGNING_SECRET=#{webhook.secret}"

        rescue Stripe::StripeError => e
          puts "❌ Error creating webhook: #{e.message}"
        end
      end
    end

    private

    define_method(:sync_plan_with_stripe) do |plan|
      puts "\nProcessing plan: #{plan.name} (#{plan.id})"

      if plan.free?
        puts "  Skipping free plan - no Stripe product needed"
        return
      end

      begin
        if plan.price_per_month.nil?
          puts "  Skipping product creation - custom pricing handled separately"
          puts "  ✓ Successfully synced plan with Stripe (no product needed)"
        else
          product = find_or_create_stripe_product(plan)
          price = find_or_create_stripe_price(plan, product)

          puts "  ✓ Successfully synced plan with Stripe"
          puts "    Product ID: #{product.id}"
          puts "    Price ID: #{price.id}"
          puts "    Lookup Key: #{price.lookup_key}"
        end

      rescue StandardError => e
        puts "  ✗ Error syncing plan: #{e.message}"
        puts "    #{e.backtrace.first}"
      end
    end

    define_method(:find_or_create_stripe_product) do |plan|
      # Try to find existing product by plan ID in metadata
      products = Stripe::Product.list(active: true)
      existing_product = products.find { |product| product.metadata["plan_id"] == plan.id }

      if existing_product
        puts "  Found existing Stripe product by plan ID: #{existing_product.id}"
        return existing_product
      end

      # Create new product with plan ID in metadata
      product = Stripe::Product.create(
        name: "Relay API: #{plan.name}",
        description: plan.description
      )

      puts "  Created new Stripe product: #{product.id}"
      puts "  Set plan_id metadata to: #{plan.id}"
      product
    end

    define_method(:find_or_create_stripe_price) do |plan, product|
      # Check if the product already has a price
      prices = Stripe::Price.list(product: product.id, active: true)
      expected_amount = (plan.price_per_month * 100).to_i

      if prices.data.any?
        existing_price = prices.data.first
        puts "  Found existing Stripe price for product: #{existing_price.id}"

        # Check if the price matches the plan's current price
        if existing_price.unit_amount == expected_amount
          puts "  Price is correct: $#{plan.price_per_month}/month"
          return existing_price
        else
          puts "  Price mismatch detected:"
          puts "    Current Stripe price: $#{(existing_price.unit_amount / 100.0).round(2)}/month"
          puts "    Expected plan price: $#{plan.price_per_month}/month"
          puts "  Creating new price and deactivating old one..."

          # Deactivate the old price
          Stripe::Price.update(existing_price.id, { active: false })
          puts "  Deactivated old price: #{existing_price.id}"
        end
      else
        puts "  No existing price found for product, creating new one"
      end

      # Create new price
      price = Stripe::Price.create(
        product: product.id,
        unit_amount: expected_amount,
        currency: "usd",
        recurring: {
          interval: "month"
        },
        nickname: "#{plan.name} Monthly",
        lookup_key: "#{plan.id}-monthly"
      )

      puts "  Created new Stripe price: #{price.id}"
      puts "  Price: $#{plan.price_per_month}/month"
      price
    end
  end
end
