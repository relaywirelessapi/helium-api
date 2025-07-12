# typed: strict

module Relay
  module Solana
    module Idl
      class ProgramDefinition
        extend T::Sig

        sig { returns(String) }
        attr_reader :address

        sig { returns(T::Hash[String, String]) }
        attr_reader :metadata

        sig { returns(T::Array[InstructionDefinition]) }
        attr_reader :instructions

        sig { returns(T::Array[AccountDefinition]) }
        attr_reader :accounts

        sig { returns(T::Array[ErrorDefinition]) }
        attr_reader :errors

        sig { returns(T::Array[FieldDefinition]) }
        attr_reader :types

        class << self
          extend T::Sig

          sig { params(file_path: T.any(String, Pathname)).returns(ProgramDefinition) }
          def from_file(file_path)
            from_data(JSON.parse(File.read(file_path)))
          end

          sig { params(data: T::Hash[String, T.untyped]).returns(ProgramDefinition) }
          def from_data(data)
            new(
              address: data.fetch("address"),
              metadata: data.fetch("metadata"),
              instructions: data.fetch("instructions").map { |instruction| InstructionDefinition.from_data(instruction) },
              accounts: data.fetch("accounts").map { |account| AccountDefinition.from_data(account) },
              errors: data.fetch("errors").map { |error| ErrorDefinition.from_data(error) },
              types: data.fetch("types").map { |type| FieldDefinition.from_data(type) },
            )
          end
        end

        sig do
          params(
            address: String,
            metadata: T::Hash[String, String],
            instructions: T::Array[InstructionDefinition],
            accounts: T::Array[AccountDefinition],
            errors: T::Array[ErrorDefinition],
            types: T::Array[FieldDefinition]
          ).void
        end
        def initialize(address:, metadata:, instructions:, accounts:, errors:, types:)
          @address = address
          @metadata = metadata
          @instructions = instructions
          @accounts = accounts
          @errors = errors
          @types = types
        end

        sig { params(name: String).returns(T.nilable(InstructionDefinition)) }
        def find_instruction(name)
          instructions.find { |instruction| instruction.name == name }
        end

        sig { params(name: String).returns(InstructionDefinition) }
        def find_instruction!(name)
          find_instruction(name) || raise(ArgumentError, "Instruction #{name} not found in IDL")
        end

        sig { params(name: String).returns(T.nilable(AccountDefinition)) }
        def find_account(name)
          accounts.find { |account| account.name == name }
        end

        sig { params(name: String).returns(AccountDefinition) }
        def find_account!(name)
          find_account(name) || raise(ArgumentError, "Account #{name} not found in IDL")
        end

        sig { params(name: String).returns(T.nilable(ErrorDefinition)) }
        def find_error(name)
          errors.find { |error| error.name == name }
        end

        sig { params(name: String).returns(ErrorDefinition) }
        def find_error!(name)
          find_error(name) || raise(ArgumentError, "Error #{name} not found in IDL")
        end

        sig { params(name: String).returns(T.nilable(FieldDefinition)) }
        def find_type(name)
          types.find { |type| type.name == name }
        end

        sig { params(name: String).returns(FieldDefinition) }
        def find_type!(name)
          find_type(name) || raise(ArgumentError, "Type #{name} not found in IDL")
        end

        sig { params(discriminator: T::Array[Integer]).returns(T.nilable(InstructionDefinition)) }
        def find_instruction_by_discriminator(discriminator)
          instructions.find { |instruction| instruction.discriminator == discriminator }
        end

        sig { params(discriminator: T::Array[Integer]).returns(InstructionDefinition) }
        def find_instruction_by_discriminator!(discriminator)
          find_instruction_by_discriminator(discriminator) ||
            raise(ArgumentError, "Instruction with discriminator #{discriminator.inspect} not found in IDL")
        end

        sig { params(instruction_data: String).returns(T.nilable(InstructionDefinition)) }
        def find_instruction_by_data(instruction_data)
          raise ArgumentError, "Instruction data too short for discriminator" if instruction_data.length < 8

          discriminator = T.cast(T.must(instruction_data[0, 8]).unpack("C*"), T::Array[Integer])
          find_instruction_by_discriminator(discriminator)
        end

        sig { params(instruction_data: String).returns(InstructionDefinition) }
        def find_instruction_by_data!(instruction_data)
          find_instruction_by_data(instruction_data) || begin
            discriminator = T.must(instruction_data[0, 8]).unpack("C*")
            raise(ArgumentError, "Instruction with discriminator #{discriminator.inspect} not found in IDL")
          end
        end
      end
    end
  end
end
