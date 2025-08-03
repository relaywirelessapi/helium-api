# typed: strict

module Relay
  module Solana
    module Idl
      class StructTypeDefinition < TypeDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(StructTypeDefinition) }
          def from_data(data)
            new(
              fields: data.fetch("fields", []).map { |field| FieldDefinition.from_data(field) }
            )
          end
        end

        sig { returns(T::Array[FieldDefinition]) }
        attr_reader :fields

        sig { params(fields: T::Array[FieldDefinition]).void }
        def initialize(fields:)
          @fields = fields
        end

        sig { params(name: String).returns(T.nilable(FieldDefinition)) }
        def find_field(name)
          fields.find { |field| field.name == name }
        end

        sig { params(name: String).returns(FieldDefinition) }
        def find_field!(name)
          find_field(name) || raise(ArgumentError, "Field #{name} not found")
        end

        sig do
          params(
            data: String,
            offset: Integer,
            program: ProgramDefinition
          ).returns([ T::Hash[String, T.untyped], Integer ])
        end
        def deserialize(data, offset:, program:)
          result = T.let({}, T::Hash[String, T.untyped])

          fields.each do |field|
            field_value, offset = field.type.deserialize(
              data,
              offset: offset,
              program: program
            )

            result[field.name] = field_value
          end

          [ result, offset ]
        end
      end
    end
  end
end
