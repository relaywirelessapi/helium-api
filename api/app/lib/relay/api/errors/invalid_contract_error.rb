# typed: true

module Relay
  module Api
    module Errors
      class InvalidContractError < BaseError
        attr_reader :contract

        def initialize(contract)
          super(
            code: "malformed_request",
            message: "The request is malformed. Please check the request parameters.",
            status_code: :bad_request,
            doc_url: "http://docs.relaywireless.com/api/relay-api"
          )

          @contract = contract
        end
      end
    end
  end
end
