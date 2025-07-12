# typed: false

RSpec.describe Relay::Helium::L2::InstructionHandlers::MakerHandler do
  describe "#handle" do
    it "syncs the maker" do
      maker_syncer = instance_spy(Relay::Helium::L2::MakerSyncer)
      instruction_definition = instance_double(Relay::Solana::Idl::InstructionDefinition)
      deserialized_instruction = instance_double(
        Relay::Solana::Idl::InstructionDefinition::DeserializedInstruction,
        accounts: { maker: "maker" }
      )

      handler = described_class.new(maker_syncer:)
      handler.handle(instruction_definition, deserialized_instruction)

      expect(maker_syncer).to have_received(:get_and_sync_maker).with("maker")
    end
  end
end
