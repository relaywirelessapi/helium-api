# typed: false

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
          details = []

          if lookback_window.nil?
            details << "Unlimited historical data access"
          else
            details << "#{format_duration(lookback_window)} historical data"
          end

          if aggregate_endpoints
            details << "aggregate endpoints included"
          else
            details << "basic endpoints only"
          end

          "#{details.join(", ")}."
        end

        private

        sig { params(duration: ActiveSupport::Duration).returns(String) }
        def format_duration(duration)
          if duration >= 1.year
            "#{(duration / 1.year).to_i} year#{duration >= 2.years ? 's' : ''}"
          elsif duration >= 1.month
            "#{(duration / 1.month).to_i} month#{duration >= 2.months ? 's' : ''}"
          elsif duration >= 1.day
            "#{(duration / 1.day).to_i} day#{duration >= 2.days ? 's' : ''}"
          else
            duration.inspect
          end
        end
      end
    end
  end
end
