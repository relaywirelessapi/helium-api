# typed: strict

module Relay
  module Solana
    module Deserializers
      class OptionDeserializer < BaseDeserializer
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
          type_definition = T.cast(type_definition, Idl::OptionTypeDefinition)

          has_value, offset = deserializer_registry.deserialize(
            data,
            offset:,
            program_definition:,
            type_definition: Idl::ScalarTypeDefinition.new(type: :u8),
          )

          return [ nil, offset ] if has_value == 0

          deserializer_registry.deserialize(
            data,
            offset:,
            program_definition:,
            type_definition: type_definition.type,
          )
        end
      end
    end
  end
end
