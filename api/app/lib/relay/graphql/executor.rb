# typed: strict
# frozen_string_literal: true

module Relay
  module Graphql
    class Executor
      extend T::Sig

      sig { returns(T.class_of(GraphQL::Schema)) }
      attr_reader :schema

      sig { returns(Relay::PostHog::Client) }
      attr_reader :posthog

      sig { params(schema: T.class_of(GraphQL::Schema), posthog: Relay::PostHog::Client).void }
      def initialize(schema:, posthog: Relay::PostHog::Client.new)
        @schema = schema
        @posthog = posthog
      end

      sig do
        params(
          query: String,
          variables: T::Hash[String, T.untyped],
          current_user: T.nilable(User)
        ).returns(GraphQL::Query::Result)
      end
      def execute(query:, variables:, current_user:)
        result = schema.execute(
          query,
          variables: variables,
          context: { current_user: current_user },
        )

        posthog.capture(
          distinct_id: current_user&.id,
          event: "graphql_query",
          properties: {
            query: query,
            variables: variables
          }
        )

        result
      end
    end
  end
end
