# typed: false

module Relay
  module Billing
    class CreatePaymentProcessorUserJob < ApplicationJob
      extend T::Sig

      sig { params(user: User).void }
      def perform(user)
        T.must(user.payment_processor).api_record
      end
    end
  end
end
