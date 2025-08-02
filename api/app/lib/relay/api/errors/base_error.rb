# typed: strict

module Relay
  module Api
    module Errors
      class BaseError < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :code

        sig { returns(String) }
        attr_reader :message

        sig { returns(Symbol) }
        attr_reader :status_code

        sig { returns(T.nilable(String)) }
        attr_reader :doc_url

        sig { params(code: String, message: String, status_code: Symbol, doc_url: T.nilable(String)).void }
        def initialize(code:, message:, status_code:, doc_url: nil)
          @code = code
          @message = message
          @status_code = status_code
          @doc_url = doc_url
        end
      end
    end
  end
end
