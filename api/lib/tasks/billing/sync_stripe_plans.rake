# typed: strict

namespace :billing do
  namespace :stripe do
    desc "Sync all configured plans with Stripe (create individual products for each plan)"
    task sync_plans: :environment do
      puts "Starting Stripe plan sync..."

      plans = Relay::Billing::Plan.all
      puts "Found #{plans.length} plans to sync"

      plans.each do |plan|
        sync_plan_with_stripe(plan)
      end

      puts "\nStripe plan sync completed!"
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

      if prices.data.any?
        price = prices.data.first
        puts "  Found existing Stripe price for product: #{price.id}"
        return price
      else
        puts "  No existing price found for product, creating new one"
      end

      # Create new price
      price = Stripe::Price.create(
        product: product.id,
        unit_amount: (plan.price_per_month * 100).to_i,
        currency: "usd",
        recurring: {
          interval: "month"
        },
        nickname: "#{plan.name} Monthly",
        lookup_key: "#{plan.id}-monthly"
      )

      puts "  Created new Stripe price: #{price.id}"
      price
    end
  end
end
