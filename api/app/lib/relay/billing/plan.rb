# typed: strict

module Relay
  module Billing
    class Plan < StaticModel
      extend T::Sig

      attribute :name, :string
      attribute :description, :string
      attribute :price_per_month, :decimal
      attribute :features, array: true, default: []

      sig { returns(T::Boolean) }
      def free?
        price_per_month == 0.00
      end

      class << self
        extend T::Sig

        sig { returns(T::Array[T.attached_class]) }
        def all
          [
            new(
              id: "beta",
              name: "Beta",
              description: "Test all Relay API features for free while we’re in beta!",
              price_per_month: 0.00,
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
              description: "Perfect for developers getting started with Helium data.",
              price_per_month: 0.00,
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
              description: "Great for small projects and startups.",
              price_per_month: 29.99,
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
              description: "Ideal for growing applications and teams.",
              price_per_month: 59.99,
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
              description: "Built for production applications with high demands.",
              price_per_month: 199.99,
              features: [
                Features::OracleData.new(lookback_window: nil, aggregate_endpoints: true),
                Features::HotspotData.new,
                Features::ApiAccess.new(calls_per_month: 1_205_000),
                Features::CustomerService.new(tier: Features::CustomerService::Tier.business)
              ]
            ),
            new(
              id: "business",
              name: "Business",
              description: "Enterprise-grade features for large-scale operations.",
              price_per_month: 449.99,
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
              description: "Custom solutions for enterprise customers.",
              price_per_month: nil,
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
