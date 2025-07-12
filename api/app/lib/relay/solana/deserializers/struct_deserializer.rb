# typed: strict

module Relay
  module Solana
    module Deserializers
      class StructDeserializer < BaseDeserializer
        extend T::Sig

        sig do
          params(
            data: String,
            offset: Integer,
            program_definition: Idl::ProgramDefinition,
            type_definition: Idl::TypeDefinition,
            deserializer_registry: DeserializerRegistry,
          ).returns([ T.untyped, Integer ])
        end
        def deserialize(data, offset:, program_definition:, type_definition:, deserializer_registry:)
          type_definition = T.cast(type_definition, Idl::StructTypeDefinition)

          result = {}

          type_definition.fields.each do |field|
            field_value, offset = deserializer_registry.deserialize(
              data,
              offset:,
              program_definition:,
              type_definition: field.type,
            )
            result[field.name] = field_value
          end

          [ result, offset ]
        end
      end
    end
  end
end
