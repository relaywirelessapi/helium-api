# typed: strict

module Relay
  module Helium
    module L2
      module InstructionHandlers
        class BaseHandler
          extend T::Sig
          extend T::Helpers

          abstract!

          sig do
            abstract.params(
              instruction_definition: Relay::Solana::Idl::InstructionDefinition,
              deserialized_instruction: Relay::Solana::Idl::InstructionDefinition::DeserializedInstruction
            ).void
          end
          def handle(instruction_definition, deserialized_instruction)
          end
        end
      end
    end
  end
end
