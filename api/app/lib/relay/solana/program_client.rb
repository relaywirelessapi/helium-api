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

      sig { params(type: String).returns(T::Array[T::Hash[String, T.untyped]]) }
      def get_accounts(type)
        account_definition = program.find_account!(type)

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

      sig { params(data: String).returns(T.untyped) }
      def deserialize_account(data)
        decoded_data = Base64.decode64(data)

        account_definition = program.find_account_from_data!(decoded_data)
        type_definition = program.find_type!(account_definition.name).type

        type_definition.deserialize(
          decoded_data,
          offset: 8,
          program: program
        ).first
      end

      sig { params(address: String).returns(T.untyped) }
      def get_and_deserialize_account(address)
        data = client.get_parsed_account_info(address).fetch("value").fetch("data")[0]

        deserialize_account(data)
      end
    end
  end
end
