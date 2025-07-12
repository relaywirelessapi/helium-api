# typed: strict

module Relay
  module Helium
    module L2
      class WebhookProcessor < Relay::Webhooks::WebhookProcessor
        extend T::Sig

        HEM_IDL_PATH = T.let(Rails.root.join("data", "idls", "helium-entity-manager.json"), Pathname)

        sig { returns(Base58Encoder) }
        attr_reader :base58_encoder

        sig { returns(Relay::Solana::Idl::ProgramDefinition) }
        attr_reader :program

        sig { params(base58_encoder: Base58Encoder, program: Relay::Solana::Idl::ProgramDefinition).void }
        def initialize(base58_encoder: Base58Encoder.new, program: Relay::Solana::Idl::ProgramDefinition.from_file(HEM_IDL_PATH))
          @base58_encoder = base58_encoder
          @program = program
        end

        sig { override.params(webhook: Relay::Webhooks::Webhook).void }
        def process(webhook)
          transactions = webhook.payload.map { |entry| Relay::Solana::Transaction.from_rpc(entry) }

          metadata = transactions.map do |transaction|
            transaction.instructions.map do |instruction|
              program_address = instruction.resolve_program(transaction)
              account_addresses = instruction.resolve_accounts(transaction)

              next unless program_address == program.address

              data = base58_encoder.data_from_base58(instruction.data)
              instruction_definition = program.find_instruction_from_data(data)

              next unless instruction_definition

              deserialized_instruction = instruction_definition.deserialize(
                data,
                account_addresses,
                program: program
              )

              {
                instruction: instruction_definition.name,
                args: deserialized_instruction.args,
                accounts: deserialized_instruction.accounts
              }
            end
          end

          webhook.update!(metadata: metadata)
        end
      end
    end
  end
end
