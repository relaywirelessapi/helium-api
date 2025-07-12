# typed: strict

module Relay
  module Solana
    class ProgramClient
      extend T::Sig

      sig { returns(Idl::ProgramDefinition) }
      attr_reader :program_definition

      sig { returns(Client) }
      attr_reader :client

      sig { returns(Base58Encoder) }
      attr_reader :base58_encoder

      sig { params(program_definition: Idl::ProgramDefinition, client: Client, base58_encoder: Base58Encoder).void }
      def initialize(program_definition, client: Client.new, base58_encoder: Base58Encoder.new)
        @program_definition = program_definition
        @client = client
        @base58_encoder = base58_encoder
      end

      sig { params(account_name: String).returns(T::Array[T::Hash[String, T.untyped]]) }
      def get_accounts(account_name)
        account_definition = program_definition.find_account!(account_name)

        client.get_program_accounts(
          program_definition.address,
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
        account_definition = program_definition.find_account!(account_name)
        type_definition = program_definition.find_type!(account_name).type

        account_definition.validate_discriminator!(account_data)

        type_definition.deserialize(
          account_data,
          offset: 8,
          program_definition: program_definition
        ).first
      end
    end
  end
end
