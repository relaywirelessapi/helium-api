# typed: false

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
      end
    end
  end
end
