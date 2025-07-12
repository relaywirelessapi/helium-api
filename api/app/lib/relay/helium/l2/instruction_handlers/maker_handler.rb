# typed: strict

module Relay
  module Helium
    module L2
      module InstructionHandlers
        class MakerHandler < BaseHandler
          extend T::Sig

          sig { returns(MakerSyncer) }
          attr_reader :maker_syncer

          sig { params(maker_syncer: MakerSyncer).void }
          def initialize(maker_syncer: MakerSyncer.new)
            @maker_syncer = maker_syncer
          end

          sig do
            override.params(
              instruction_definition: Relay::Solana::Idl::InstructionDefinition,
              deserialized_instruction: Relay::Solana::Idl::InstructionDefinition::DeserializedInstruction
            ).void
          end
          def handle(instruction_definition, deserialized_instruction)
            maker = deserialized_instruction.accounts.fetch(:maker)
            maker_syncer.get_and_sync_maker(maker)
          end
        end
      end
    end
  end
end
