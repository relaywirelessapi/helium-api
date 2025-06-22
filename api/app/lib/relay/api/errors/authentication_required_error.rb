# typed: true

module Relay
  module Api
    module Errors
      class AuthenticationRequiredError < BaseError
        def initialize
          super(
            code: "authentication_required",
            message: "This API endpoint requires authentication. Please provide a valid API key in the Authorization header.",
            status_code: :unauthorized,
            doc_url: "https://docs.relaywireless.com/authentication"
          )
        end
      end
    end
  end
end
