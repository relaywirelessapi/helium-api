# typed: strict

module Relay
  module Api
    module Errors
      class RateLimitExceededError < BaseError
        extend T::Sig

        sig { void }
        def initialize
          super(
            code: "rate_limit_exceeded",
            message: "You have been rate limited. Please try again later.",
            status_code: :too_many_requests,
            doc_url: "https://docs.relaywireless.com/usage-limits#rate-limiting"
          )
        end
      end
    end
  end
end
