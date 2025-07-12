# typed: strict

module Relay
  module Solana
    module Deserializers
      class BaseDeserializer
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
          raise NotImplementedError, "Deserializers must implement #deserialize"
        end
      end
    end
  end
end
