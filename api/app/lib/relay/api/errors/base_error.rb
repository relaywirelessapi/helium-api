# typed: true

module Relay
  module Api
    module Errors
      class BaseError < StandardError
        attr_reader :code, :message, :status_code, :doc_url

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
