# typed: strict

module Relay
  module Webhooks
    class WebhooksController < ApplicationController
      extend T::Sig

      before_action :verify_webhook_key, only: :create

      protect_from_forgery with: :null_session

      sig { void }
      def create
        webhook = Webhook.create!(payload: JSON.parse(request.body.read), source: params[:source])

        ProcessWebhookJob.perform_later(webhook)

        head :no_content
      end

      private

      sig { void }
      def verify_webhook_key
        authentication_key = request.headers["Authorization"].to_s.split(" ").last

        return if ENV.fetch("WEBHOOK_AUTH_KEYS").split(",").include?(authentication_key)

        head :unauthorized
      end
    end
  end
end
