# typed: strict

module Relay
  module Solana
    module Deserializers
      class EnumDeserializer < BaseDeserializer
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
          type_definition = T.cast(type_definition, Idl::EnumTypeDefinition)

          discriminant, offset = deserializer_registry.deserialize(
            data,
            offset:,
            program_definition:,
            type_definition: Idl::ScalarTypeDefinition.new(type: :u8),
          )

          if discriminant < 0 || discriminant >= type_definition.variants.length
            raise(
              DeserializationError,
              "Invalid enum discriminant: expected 0..#{type_definition.variants.length - 1}, got #{discriminant}"
            )
          end

          variant = type_definition.variants.fetch(discriminant)

          variant_data = {}

          variant.fields.each do |field|
            field_value, offset = deserializer_registry.deserialize(
              data,
              offset:,
              program_definition:,
              type_definition: field.type,
            )

            variant_data[field.name.to_sym] = field_value
          end

          [ { variant: variant.name, data: variant_data }, offset ]
        end
      end
    end
  end
end
