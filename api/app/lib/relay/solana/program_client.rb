# typed: strict

module Relay
  module Solana
    class ProgramClient
      extend T::Sig

      sig { returns(Idl::ProgramDefinition) }
      attr_reader :program

      sig { returns(Client) }
      attr_reader :client

      sig { returns(Base58Encoder) }
      attr_reader :base58_encoder

      sig { params(program: Idl::ProgramDefinition, client: Client, base58_encoder: Base58Encoder).void }
      def initialize(program, client: Client.new, base58_encoder: Base58Encoder.new)
        @program = program
        @client = client
        @base58_encoder = base58_encoder
      end

      sig { params(account_name: String).returns(T::Array[T::Hash[String, T.untyped]]) }
      def get_accounts(account_name)
        account_definition = program.find_account!(account_name)

        client.get_program_accounts(
          program.address,
          {
            encoding: "base64",
            commitment: "finalized",
            filters: [
              {
                memcmp: {
                  offset: 0,
                  bytes: base58_encoder.base58_from_data(account_definition.discriminator.pack("C*"))
                }
              }
            ]
          }
        )
      end

      sig { params(account_name: String, account_data: String).returns(T.untyped) }
      def deserialize_account(account_name, account_data)
        account_definition = program.find_account!(account_name)
        type_definition = program.find_type!(account_name).type

        account_definition.validate_discriminator!(account_data)

        type_definition.deserialize(
          account_data,
          offset: 8,
          program: program
        ).first
      end
    end
  end
end
