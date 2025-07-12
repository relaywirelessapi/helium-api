# typed: strict

module Relay
  module Webhooks
    class WebhookProcessor
      extend T::Sig
      extend T::Helpers

      abstract!

      sig { abstract.params(webhook: Webhook).void }
      def process(webhook)
      end
    end
  end
end
