# typed: strict

module Relay
  module Solana
    class Instruction
      extend T::Sig

      sig { returns(Integer) }
      attr_reader :program_index

      sig { returns(String) }
      attr_reader :data

      sig { returns(T::Array[Integer]) }
      attr_reader :account_indices

      class << self
        extend T::Sig

        sig { params(instruction: T::Hash[T.untyped, T.untyped]).returns(Instruction) }
        def from_rpc(instruction)
          new(
            program_index: instruction.fetch("programIdIndex"),
            data: instruction.fetch("data"),
            account_indices: instruction.fetch("accounts")
          )
        end
      end

      sig { params(program_index: Integer, data: String, account_indices: T::Array[Integer]).void }
      def initialize(program_index:, data:, account_indices:)
        @program_index = program_index
        @data = data
        @account_indices = account_indices
      end

      sig { params(transaction: Transaction).returns(String) }
      def resolve_program(transaction)
        transaction.accounts.fetch(program_index)
      end

      sig { params(transaction: Transaction).returns(T::Array[String]) }
      def resolve_accounts(transaction)
        account_indices.map { |index| transaction.accounts.fetch(index) }
      end
    end
  end
end
