# typed: strict

module Relay
  module Solana
    module Idl
      class InstructionDefinition
        extend T::Sig

        sig { returns(String) }
        attr_reader :name

        sig { returns(T::Array[Integer]) }
        attr_reader :discriminator

        sig { returns(T::Array[InstructionAccountDefinition]) }
        attr_reader :accounts

        sig { returns(T::Array[InstructionArgDefinition]) }
        attr_reader :args

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(InstructionDefinition) }
          def from_data(data)
            new(
              name: data.fetch("name"),
              discriminator: data.fetch("discriminator"),
              accounts: data.fetch("accounts").map { |account_data| InstructionAccountDefinition.from_data(account_data) },
              args: data.fetch("args").map { |arg_data| InstructionArgDefinition.from_data(arg_data) },
            )
          end
        end

        class DeserializedInstruction
          extend T::Sig

          sig { returns(T::Hash[Symbol, T.untyped]) }
          attr_reader :args

          sig { returns(T::Hash[Symbol, String]) }
          attr_reader :accounts

          sig { params(args: T::Hash[Symbol, T.untyped], accounts: T::Hash[Symbol, String]).void }
          def initialize(args:, accounts:)
            @args = args
            @accounts = accounts
          end
        end

        sig do
          params(
            name: String,
            discriminator: T::Array[Integer],
            accounts: T::Array[InstructionAccountDefinition],
            args: T::Array[InstructionArgDefinition]
          ).void
        end
        def initialize(name:, discriminator:, accounts:, args:)
          @name = name
          @discriminator = discriminator
          @accounts = accounts
          @args = args
        end

        sig { params(data: String).returns(T::Boolean) }
        def matches_discriminator?(data)
          extract_discriminator(data) == discriminator
        end

        sig do
          params(
            data: String,
            accounts: T::Array[String],
            program_definition: ProgramDefinition
          ).returns(DeserializedInstruction)
        end
        def deserialize(data, accounts, program_definition:)
          unless matches_discriminator?(data)
            raise ArgumentError, "Instruction discriminator does not match for '#{name}'. Expected #{discriminator.inspect}, got #{extract_discriminator(data).inspect}"
          end

          args_data = data[8..-1] || ""

          DeserializedInstruction.new(
            args: map_args(args_data, program_definition),
            accounts: map_accounts(accounts)
          )
        end

        private

        sig { params(args_data: String, program_definition: ProgramDefinition).returns(T::Hash[Symbol, T.untyped]) }
        def map_args(args_data, program_definition)
          offset = 0

          args.map do |arg_definition|
            value, offset = arg_definition.type.deserialize(
              args_data,
              offset: offset,
              program_definition: program_definition
            )

            [ arg_definition.name.to_sym, value ]
          end.to_h
        end

        sig { params(account_addresses: T::Array[String]).returns(T::Hash[Symbol, String]) }
        def map_accounts(account_addresses)
          accounts.map.with_index do |account_definition, index|
            address = account_addresses[index]

            [ account_definition.name, address ]
          end.to_h
        end

        sig { params(data: String).returns(T::Array[Integer]) }
        def extract_discriminator(data)
          T.cast(T.must(data[0, 8]).unpack("C*"), T::Array[Integer])
        end
      end
    end
  end
end
