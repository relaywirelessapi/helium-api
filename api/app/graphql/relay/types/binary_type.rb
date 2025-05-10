# typed: strict
# frozen_string_literal: true

module Relay
  module Types
    class BinaryType < GraphQL::Schema::Scalar
      description "A scalar type that represents binary data, automatically encoded as Base64"

      class << self
        extend T::Sig

        sig { params(value: T.nilable(T.any(String, T.untyped)), _context: GraphQL::Query::Context).returns(T.nilable(String)) }
        def coerce_input(value, _context)
          return unless value

          if value.is_a?(String) && value.encoding == Encoding::ASCII_8BIT
            Base64.strict_encode64(value)
          else
            raise GraphQL::CoercionError, "Cannot coerce #{value.class} to Base64"
          end
        end

        sig { params(value: T.nilable(T.any(String, T.untyped)), context: GraphQL::Query::Context).returns(T.nilable(String)) }
        def coerce_result(value, context)
          coerce_input(value, context)
        end
      end
    end
  end
end
