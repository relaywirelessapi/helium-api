# typed: strict

module Relay
  module Solana
    module Deserializers
      class DefinedTypeDeserializer < BaseDeserializer
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
          type_definition = T.cast(type_definition, Idl::DefinedTypeDefinition)
          type_definition = program_definition.find_type!(type_definition.name).type
          deserializer_registry.deserialize(data, offset:, program_definition:, type_definition: type_definition)
        end
      end
    end
  end
end
