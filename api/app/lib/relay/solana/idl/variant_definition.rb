# typed: strict

module Relay
  module Solana
    module Idl
      class VariantDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(VariantDefinition) }
          def from_data(data)
            new(
              name: data.fetch("name"),
              fields: data.fetch("fields", []).map { |field| FieldDefinition.from_data(field) }
            )
          end
        end

        sig { returns(String) }
        attr_reader :name

        sig { returns(T::Array[FieldDefinition]) }
        attr_reader :fields

        sig { params(name: String, fields: T::Array[FieldDefinition]).void }
        def initialize(name:, fields:)
          @name = name
          @fields = fields
        end
      end
    end
  end
end
