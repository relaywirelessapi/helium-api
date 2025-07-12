# typed: strict

module Relay
  module Helium
    module L2
      class WebhookProcessor < Relay::Webhooks::WebhookProcessor
        extend T::Sig

        sig { override.params(webhook: Relay::Webhooks::Webhook).void }
        def process(webhook)
        end
      end
    end
  end
end
