# typed: strict

module Relay
  module Solana
    class InstructionDeserializer
      extend T::Sig

      sig { returns(Idl::ProgramDefinition) }
      attr_reader :program_definition

      sig { returns(DeserializerRegistry) }
      attr_reader :deserializer_registry

      sig do
        params(
          program_definition: Idl::ProgramDefinition,
          deserializer_registry: DeserializerRegistry
        ).void
      end
      def initialize(program_definition, deserializer_registry: DeserializerRegistry.new)
        @program_definition = program_definition
        @deserializer_registry = deserializer_registry
      end

      sig { params(instruction_data: String, account_addresses: T::Array[String]).returns(T::Hash[String, T.untyped]) }
      def deserialize(instruction_data, account_addresses: [])
        instruction_definition = program_definition.find_instruction_by_data!(instruction_data)
        args_data = instruction_data[8..-1] || ""

        {
          instruction_definition: instruction_definition,
          args: map_args(instruction_definition, args_data),
          accounts: map_accounts(instruction_definition, account_addresses)
        }
      end

      private

      sig { params(instruction_definition: Idl::InstructionDefinition, args_data: String).returns(T::Array[T::Hash[String, T.untyped]]) }
      def map_args(instruction_definition, args_data)
        result = []
        offset = 0

        instruction_definition.args.each do |arg_definition|
          value, offset = deserializer_registry.deserialize(
            args_data,
            offset: offset,
            program_definition: program_definition,
            type_definition: arg_definition.type
          )

          result << {
            arg_definition: arg_definition,
            value: value,
          }
        end

        result
      end

      sig do
        params(
          instruction_definition: Idl::InstructionDefinition,
          account_addresses: T::Array[String]
        ).returns(T::Array[T::Hash[String, T.untyped]])
      end
      def map_accounts(instruction_definition, account_addresses)
        instruction_definition.accounts.map.with_index do |account_definition, index|
          address = account_addresses[index]

          {
            account_definition: account_definition,
            address: address,
          }
        end
      end
    end
  end
end
