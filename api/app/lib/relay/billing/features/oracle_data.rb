# typed: strict

module Relay
  module Billing
    module Features
      class OracleData < Feature
        extend T::Sig

        EARLIEST_DATA_AVAILABLE_FROM = T.let(Date.parse("2023-04-08"), Date)

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

          details += " (starting #{lookback_window_start_date.strftime("%B %d, %Y")})"

          if aggregate_endpoints
            details += " with aggregate endpoints."
          else
            details += " with basic endpoints only."
          end

          details
        end

        sig { returns(Date) }
        def lookback_window_start_date
          window = lookback_window

          if window
            [ Time.zone.today - window, EARLIEST_DATA_AVAILABLE_FROM ].max
          else
            EARLIEST_DATA_AVAILABLE_FROM
          end
        end
      end
    end
  end
end
