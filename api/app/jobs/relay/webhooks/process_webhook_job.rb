# typed: strict

module Relay
  module Webhooks
    class ProcessWebhookJob < ApplicationJob
      extend T::Sig

      queue_as :default

      sig { params(webhook: Webhook).void }
      def perform(webhook)
        return if webhook.processed?

        webhook.processor.process(webhook)

        webhook.update!(processed_at: Time.current)
      end
    end
  end
end
