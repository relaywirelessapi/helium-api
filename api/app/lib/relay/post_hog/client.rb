# typed: strict
# frozen_string_literal: true

module Relay
  module PostHog
    class Client
      extend T::Sig

      sig { returns(String) }
      attr_reader :api_key

      sig { returns(String) }
      attr_reader :host

      sig { params(api_key: String, host: String).void }
      def initialize(api_key: ENV.fetch("POSTHOG_API_KEY"), host: ENV.fetch("POSTHOG_HOST"))
        @api_key = api_key
        @host = host
      end

      sig { params(distinct_id: T.nilable(T.any(String, Integer)), event: String, properties: T::Hash[Symbol, T.untyped]).void }
      def capture(distinct_id:, event:, properties: {})
        posthog.capture({
          distinct_id: distinct_id || SecureRandom.uuid,
          event: event,
          properties: properties.merge(
            "$process_person_profile" => distinct_id.present?,
          )
        })
      rescue StandardError => e
        raise e if Rails.env.development?
        Sentry.capture_exception(e)
      end

      private

      sig { returns(::PostHog::Client) }
      def posthog
        @posthog ||= T.let(
          ::PostHog::Client.new({
            api_key: api_key,
            host: host,
            on_error: Proc.new { |status, msg| print msg }
          }),
          T.nilable(::PostHog::Client)
        )
      end
    end
  end
end
