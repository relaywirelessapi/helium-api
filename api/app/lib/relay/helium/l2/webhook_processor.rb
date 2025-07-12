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
          metadata = webhook.payload.map do |entry|
            transaction = entry.fetch("transaction")
            meta = entry.fetch("meta")
            message = transaction.fetch("message")
            instructions = message.fetch("instructions")

            account_keys = message.fetch("accountKeys")
            loaded_writable = Array(meta.dig("loadedAddresses", "writable"))
            loaded_readonly = Array(meta.dig("loadedAddresses", "readonly"))
            accounts = account_keys + loaded_writable + loaded_readonly

            instructions.map do |instruction|
              program_id_index = instruction.fetch("programIdIndex")
              program_id = accounts[program_id_index]
              next unless program_id == program.address

              data = base58_encoder.data_from_base58(instruction.fetch("data"))
              instruction_def = program.find_instruction_from_data(data)
              next unless instruction_def

              instruction_account_indices = instruction.fetch("accounts")
              instruction_account_keys = instruction_account_indices.map { |i| accounts[i] }

              deserialized_instruction = instruction_def.deserialize(data, instruction_account_keys, program: program)

              {
                instruction: instruction_def.name,
                args: deserialized_instruction.args,
                accounts: deserialized_instruction.accounts
              }
            end.compact
          end

          webhook.update!(metadata: metadata)
        end
      end
    end
  end
end
