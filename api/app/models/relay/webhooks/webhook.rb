# typed: strict

module Relay
  module Webhooks
    class Webhook < ApplicationRecord
      extend T::Sig

      self.table_name = "webhooks"

      sig { returns(Relay::Helium::L2::WebhookProcessor) }
      def processor
        case source
        when "helius"
          Relay::Helium::L2::WebhookProcessor.new
        else
          raise "Unknown webhook source: #{source}"
        end
      end

      sig { returns(T::Boolean) }
      def processed?
        processed_at.present?
      end
    end
  end
end
