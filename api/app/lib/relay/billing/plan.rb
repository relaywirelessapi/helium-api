# typed: strict

module Relay
  module Billing
    class Plan < StaticModel
      extend T::Sig

      attribute :name, :string
      attribute :description, :string
      attribute :price_per_month, :decimal
      attribute :features, array: true, default: []
      attribute :visible, :boolean, default: false

      class << self
        extend T::Sig

        sig { returns(T::Array[T.attached_class]) }
        def all
          [
            new(
              id: "beta",
              name: "Beta",
              description: "Test all Relay API features for free during beta!",
              price_per_month: 0.00,
              visible: false,
              features: [
                Features::ApiAccess.new(calls_per_month: 10_000),
                Features::OracleData.new(lookback_window: nil, aggregate_endpoints: true),
                Features::HotspotData.new,
                Features::CustomerService.new(tier: Features::CustomerService::Tier.community)
              ]
            ),
            new(
              id: "community",
              name: "Community",
              description: "Perfect for developers getting started with on-chain and off-chain Helium data.",
              price_per_month: 0.00,
              visible: true,
              features: [
                Features::ApiAccess.new(calls_per_month: 10_000),
                Features::OracleData.new(lookback_window: 30.days, aggregate_endpoints: false),
                Features::HotspotData.new,
                Features::CustomerService.new(tier: Features::CustomerService::Tier.community)
              ]
            ),
            new(
              id: "starter",
              name: "Starter",
              description: "Great for small projects and growing startups that need basic data access.",
              price_per_month: 29.99,
              visible: true,
              features: [
                Features::ApiAccess.new(calls_per_month: 105_000),
                Features::OracleData.new(lookback_window: 90.days, aggregate_endpoints: true),
                Features::HotspotData.new,
                Features::CustomerService.new(tier: Features::CustomerService::Tier.business)
              ]
            ),
            new(
              id: "enthusiast",
              name: "Enthusiast",
              description: "Ideal for growing businesses that need better rate limits and lookback windows.",
              price_per_month: 59.99,
              visible: true,
              features: [
                Features::ApiAccess.new(calls_per_month: 305_000),
                Features::OracleData.new(lookback_window: 1.year, aggregate_endpoints: true),
                Features::HotspotData.new,
                Features::CustomerService.new(tier: Features::CustomerService::Tier.business)
              ]
            ),
            new(
              id: "professional",
              name: "Professional",
              description: "Built for production applications that require unlimited data lookback.",
              price_per_month: 199.99,
              visible: true,
              features: [
                Features::ApiAccess.new(calls_per_month: 1_205_000),
                Features::OracleData.new(lookback_window: nil, aggregate_endpoints: true),
                Features::HotspotData.new,
                Features::CustomerService.new(tier: Features::CustomerService::Tier.business)
              ]
            ),
            new(
              id: "business",
              name: "Business",
              description: "Designed for established businesses that need high-volume access and premium support.",
              price_per_month: 449.99,
              visible: true,
              features: [
                Features::ApiAccess.new(calls_per_month: 3_005_000),
                Features::OracleData.new(lookback_window: nil, aggregate_endpoints: true),
                Features::HotspotData.new,
                Features::CustomerService.new(tier: Features::CustomerService::Tier.business)
              ]
            ),
            new(
              id: "enterprise",
              name: "Enterprise",
              description: "Custom solutions for enterprise customers and teams that can't cope with rate limits.",
              price_per_month: nil,
              visible: true,
              features: [
                Features::ApiAccess.new(calls_per_month: nil),
                Features::OracleData.new(lookback_window: nil, aggregate_endpoints: true),
                Features::HotspotData.new,
                Features::CustomerService.new(tier: Features::CustomerService::Tier.business)
              ]
            )
          ]
        end
      end

      sig { returns(T::Boolean) }
      def free?
        price_per_month == 0.00
      end

      sig { returns(T::Boolean) }
      def custom_pricing?
        price_per_month.nil?
      end

      sig { params(other_plan: Plan).returns(T::Boolean) }
      def upgrade?(other_plan)
        this_price_per_month = price_per_month
        other_price_per_month = other_plan.price_per_month

        return false if this_price_per_month.nil? || other_price_per_month.nil?

        this_price_per_month > other_price_per_month
      end

      sig { params(other_plan: Plan).returns(T::Boolean) }
      def downgrade?(other_plan)
        this_price_per_month = price_per_month
        other_price_per_month = other_plan.price_per_month

        return false if this_price_per_month.nil? || other_price_per_month.nil?

        this_price_per_month < other_price_per_month
      end

      sig { returns(String) }
      def stripe_price_lookup_key
         "#{id}-monthly"
      end

      sig { returns(T.nilable(Stripe::Price)) }
      def stripe_price
        Stripe::Price.list(lookup_keys: [ stripe_price_lookup_key ]).first
      end

      sig { params(klass: T.class_of(Feature)).returns(T.nilable(Feature)) }
      def find_feature(klass)
        features.find { |feature| feature.is_a?(klass) }
      end

      sig { params(klass: T.class_of(Feature)).returns(Feature) }
      def find_feature!(klass)
        find_feature(klass) or raise "Feature #{klass} not found in plan #{name}"
      end

      sig { params(klass: T.class_of(Feature)).returns(T::Boolean) }
      def feature?(klass)
        !!find_feature(klass)
      end
    end
  end
end
