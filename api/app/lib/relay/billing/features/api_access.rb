# typed: strict

module Relay
  module Billing
    module Features
      class ApiAccess < Feature
        include ActiveSupport::NumberHelper

        extend T::Sig

        sig { returns(T.nilable(Integer)) }
        attr_reader :calls_per_month

        sig { params(calls_per_month: T.nilable(Integer)).void }
        def initialize(calls_per_month:)
          @calls_per_month = calls_per_month
        end

        sig { override.returns(String) }
        def name
          "API access"
        end

        sig { override.returns(String) }
        def description
          if calls_per_month
            "#{number_to_delimited(T.must(calls_per_month))} API calls per month"
          else
            "Unlimited API calls per month"
          end
        end
      end
    end
  end
end
