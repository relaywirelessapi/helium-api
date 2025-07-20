# typed: strict

module Relay
  module Helium
    module L2
      module InstructionHandlers
        class HotspotHandler < BaseHandler
          extend T::Sig

          HEM_IDL_PATH = T.let(Rails.root.join("data/idls/helium-entity-manager.json"), Pathname)

          sig { returns(HotspotSyncer) }
          attr_reader :hotspot_syncer

          sig { returns(Relay::Solana::ProgramClient) }
          attr_reader :program_client

          sig { params(hotspot_syncer: HotspotSyncer, program_client: Relay::Solana::ProgramClient).void }
          def initialize(hotspot_syncer: HotspotSyncer.new, program_client: Relay::Solana::ProgramClient.new(Relay::Solana::Idl::ProgramDefinition.from_file(HEM_IDL_PATH)))
            @hotspot_syncer = hotspot_syncer
            @program_client = program_client
          end

          sig do
            override.params(
              instruction_definition: Relay::Solana::Idl::InstructionDefinition,
              deserialized_instruction: Relay::Solana::Idl::InstructionDefinition::DeserializedInstruction
            ).void
          end
          def handle(instruction_definition, deserialized_instruction)
            info_address = if deserialized_instruction.accounts.key?(:iot_info)
              deserialized_instruction.accounts.fetch(:iot_info)
            elsif deserialized_instruction.accounts.key?(:mobile_info)
              deserialized_instruction.accounts.fetch(:mobile_info)
            else
              deserialized_instruction.accounts.fetch(:info)
            end

            info_account = program_client.get_and_deserialize_account(info_address)

            hotspot_syncer.sync_hotspot(info_account.fetch(:asset))
          end
        end
      end
    end
  end
end
