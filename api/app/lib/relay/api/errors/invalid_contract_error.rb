# typed: strict

module Relay
  module Api
    module Errors
      class InvalidContractError < BaseError
        extend T::Sig

        sig { returns(T.class_of(Relay::Api::Contract)) }
        attr_reader :contract

        sig { params(contract: T.class_of(Relay::Api::Contract)).void }
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
