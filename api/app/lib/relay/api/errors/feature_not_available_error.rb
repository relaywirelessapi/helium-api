# typed: strict

module Relay
  module Api
    module Errors
      class FeatureNotAvailableError < BaseError
        extend T::Sig

        sig { void }
        def initialize
          super(
            code: "feature_not_available",
            message: "Your plan doesn't include access to this feature. Please upgrade your plan or contact support for more information.",
            status_code: :unauthorized,
            doc_url: "https://www.relaywireless.com/#pricing"
          )
        end
      end
    end
  end
end
