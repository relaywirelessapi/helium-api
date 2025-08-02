# typed: strict

module Relay
  module Billing
    module Features
      class OracleData < Feature
        extend T::Sig

        sig { returns(T.nilable(ActiveSupport::Duration)) }
        attr_reader :lookback_window

        sig { returns(T::Boolean) }
        attr_reader :aggregate_endpoints

        sig { params(lookback_window: T.nilable(ActiveSupport::Duration), aggregate_endpoints: T::Boolean).void }
        def initialize(lookback_window:, aggregate_endpoints:)
          @lookback_window = lookback_window
          @aggregate_endpoints = aggregate_endpoints
        end

        sig { override.returns(String) }
        def name
          "Oracle data"
        end

        sig { override.returns(String) }
        def description
          details = ""

          if lookback_window
            formatted_lookback_window = T.must(lookback_window).parts.map { |unit, value| "#{value} #{unit.pluralize(value)}" }.join(", ")
            details += "#{formatted_lookback_window} data lookback"
          else
            details += "Unlimited data lookback"
          end

          if aggregate_endpoints
            details += " with aggregate endpoints."
          else
            details += " with basic endpoints only."
          end

          details
        end
      end
    end
  end
end
