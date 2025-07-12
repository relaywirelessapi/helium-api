# typed: strict

module Relay
  module Solana
    class Transaction
      extend T::Sig

      sig { returns(T::Array[String]) }
      attr_reader :accounts

      sig { returns(T::Array[Instruction]) }
      attr_reader :instructions

      class << self
        extend T::Sig

        sig { params(response: T::Hash[T.untyped, T.untyped]).returns(Transaction) }
        def from_rpc(response)
          accounts = [
            response.fetch("transaction").fetch("message").fetch("accountKeys"),
            Array(response.fetch("meta").dig("loadedAddresses", "writable")),
            Array(response.fetch("meta").dig("loadedAddresses", "readonly"))
          ].flatten

          instructions = response.fetch("transaction").fetch("message").fetch("instructions").map do |instruction|
            Instruction.from_rpc(instruction)
          end

          new(accounts:, instructions:)
        end
      end

      sig { params(accounts: T::Array[String], instructions: T::Array[Instruction]).void }
      def initialize(accounts:, instructions:)
        @accounts = accounts
        @instructions = instructions
      end
    end
  end
end
