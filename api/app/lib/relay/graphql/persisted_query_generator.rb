# typed: strict
# frozen_string_literal: true

module Relay
  module Graphql
    class PersistedQueryGenerator
      extend T::Sig

      sig { returns(T.class_of(GraphQL::Schema)) }
      attr_reader :schema

      sig { returns(Integer) }
      attr_reader :max_depth

      sig { returns(T::Array[String]) }
      attr_reader :ignored_fields

      sig { params(schema: T.class_of(GraphQL::Schema), max_depth: Integer, ignored_fields: T::Array[String]).void }
      def initialize(schema, max_depth: 1, ignored_fields: [ "edges" ])
        @schema = schema
        @max_depth = max_depth
        @ignored_fields = ignored_fields
      end

      sig { params(field_name: String).returns(String) }
      def query_for(field_name)
        query_type = schema.types["Query"]
        field = query_type.fields[field_name]
        raise ArgumentError, "Field '#{field_name}' not found on Query type" unless field

        field_type = field.type.unwrap

        variable_definitions = field.arguments.map do |name, arg|
          "$#{name}: #{arg.type.to_type_signature}"
        end.join(", ")

        field_arguments = field.arguments.map do |name, _|
          "#{name}: $#{name}"
        end.join(", ")

        <<~GRAPHQL
          query #{field_name.camelize}(#{variable_definitions}) {
            #{field_name}(#{field_arguments}) {
              #{fields_for(field_type)}
            }
          }
        GRAPHQL
      end

      private

      sig { params(type: T.class_of(GraphQL::Schema::Object), current_depth: Integer, visited_types: T::Array[String]).returns(String) }
      def fields_for(type, current_depth: 0, visited_types: [])
        return "" if current_depth > max_depth || visited_types.include?(type.graphql_name)

        visited_types = visited_types + [ type.graphql_name ]

        fields = type.fields.values.map do |field|
          next if ignored_fields.include?(field.name)

          field_type = field.type.unwrap

          if field_type.kind.scalar? || field_type.kind.enum?
            field.name
          elsif field_type.kind.union?
            fragments = field_type.possible_types.map do |possible_type|
              nested_fields = fields_for(
                possible_type,
                current_depth: current_depth + 1,
                visited_types: visited_types
              )
              if nested_fields.strip.empty?
                "... on #{possible_type.graphql_name} { id }"
              else
                "... on #{possible_type.graphql_name} {\n      #{nested_fields.gsub(/^/, '  ')}\n    }"
              end
            end
            "#{field.name} {\n      #{fragments.join("\n      ")}\n    }"
          elsif field_type.kind.object? && current_depth < max_depth
            next if visited_types.include?(field_type.graphql_name)

            nested_fields = fields_for(
              field_type,
              current_depth: current_depth + 1,
              visited_types: visited_types
            )

            if nested_fields.strip.empty?
              "#{field.name} { id }"
            else
              "#{field.name} {\n      #{nested_fields.gsub(/^/, '  ')}\n    }"
            end
          end
        end.compact

        fields.join("\n    ")
      end
    end
  end
end
