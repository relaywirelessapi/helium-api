# typed: false

module Relay
  module Billing
    module Features
      class ApiAccess < Feature
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
          if calls_per_month.nil?
            "Unlimited API calls per month."
          else
            "#{number_with_delimiter(calls_per_month)} API calls per month."
          end
        end

        private

        sig { params(number: Integer).returns(String) }
        def number_with_delimiter(number)
          number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        end
      end
    end
  end
end
