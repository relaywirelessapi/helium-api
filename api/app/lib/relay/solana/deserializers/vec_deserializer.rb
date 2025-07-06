# typed: strict

module Relay
  module Solana
    module Deserializers
      class VecDeserializer < BaseDeserializer
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
          type_definition = T.cast(type_definition, Idl::VecTypeDefinition)

          length, offset = deserializer_registry.deserialize(
            data,
            offset:,
            program_definition:,
            type_definition: Idl::ScalarTypeDefinition.new(type: :u32)
          )

          result = []

          (0...length).each do
            value, offset = deserializer_registry.deserialize(
              data,
              offset:,
              program_definition:,
              type_definition: type_definition.type
            )

            result << value
          end

          [ result, offset ]
        end
      end
    end
  end
end
