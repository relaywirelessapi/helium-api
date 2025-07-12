# typed: strict

module Relay
  module Solana
    class DeserializerRegistry
      extend T::Sig

      sig { returns(T::Hash[T.class_of(Idl::TypeDefinition), Deserializers::BaseDeserializer]) }
      attr_reader :deserializers

      sig { params(deserializers: T::Hash[T.class_of(Idl::TypeDefinition), Deserializers::BaseDeserializer]).void }
      def initialize(deserializers: {
        Idl::ScalarTypeDefinition => Deserializers::ScalarDeserializer.new,
        Idl::StructTypeDefinition => Deserializers::StructDeserializer.new,
        Idl::EnumTypeDefinition => Deserializers::EnumDeserializer.new,
        Idl::OptionTypeDefinition => Deserializers::OptionDeserializer.new,
        Idl::VecTypeDefinition => Deserializers::VecDeserializer.new,
        Idl::ArrayTypeDefinition => Deserializers::ArrayDeserializer.new,
        Idl::DefinedTypeDefinition => Deserializers::DefinedTypeDeserializer.new
      })
        @deserializers = deserializers
      end

      sig do
        params(
          data: String,
          offset: Integer,
          program_definition: Idl::ProgramDefinition,
          type_definition: Idl::TypeDefinition,
        ).returns([ T.untyped, Integer ])
      end
      def deserialize(data, offset:, program_definition:, type_definition:)
        deserializer = find_deserializer_for!(type_definition)
        deserializer.deserialize(data, offset:, program_definition:, type_definition:, deserializer_registry: self)
      end

      private

      sig { params(type_definition: Idl::TypeDefinition).returns(T.nilable(Deserializers::BaseDeserializer)) }
      def find_deserializer_for(type_definition)
        deserializers[type_definition.class]
      end

      sig { params(type_definition: Idl::TypeDefinition).returns(Deserializers::BaseDeserializer) }
      def find_deserializer_for!(type_definition)
        find_deserializer_for(type_definition) || raise("Unsupported field type: #{type_definition.inspect}")
      end
    end
  end
end
