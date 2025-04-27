# typed: true
# frozen_string_literal: true

module Relay
  class ApplicationSchema < GraphQL::Schema
    default_max_page_size 100
    query Types::QueryType

    use GraphQL::Dataloader

    max_query_string_tokens(5000)
    validate_max_errors(100)

    query_analyzer Analyzers::ComplexityAnalyzer

    class << self
      def id_from_object(object, type_definition, query_ctx)
        object.to_gid_param
      end

      def object_from_id(global_id, query_ctx)
        GlobalID.find(global_id)
      end
    end
  end
end
