# typed: false

RSpec.describe Relay::Helium::L2::InstructionHandlers::HotspotHandler do
  describe "#handle" do
    it "syncs the hotspot using iot_info account" do
      hotspot_syncer = stub_hotspot_syncer
      program_client = stub_program_client("iot_info_address" => { asset: "asset_id_123" })

      handler = described_class.new(hotspot_syncer:, program_client:)
      handler.handle(stub_instruction_definition, stub_deserialized_instruction(accounts: { iot_info: "iot_info_address" }))

      expect(hotspot_syncer).to have_received(:sync_hotspot).with("asset_id_123")
    end

    it "syncs the hotspot using mobile_info account" do
      hotspot_syncer = stub_hotspot_syncer
      program_client = stub_program_client("mobile_info_address" => { asset: "asset_id_456" })

      handler = described_class.new(hotspot_syncer:, program_client:)
      handler.handle(stub_instruction_definition, stub_deserialized_instruction(accounts: { mobile_info: "mobile_info_address" }))

      expect(hotspot_syncer).to have_received(:sync_hotspot).with("asset_id_456")
    end

    it "syncs the hotspot using info account" do
      hotspot_syncer = stub_hotspot_syncer
      program_client = stub_program_client("info_address" => { asset: "asset_id_789" })

      handler = described_class.new(hotspot_syncer:, program_client:)
      handler.handle(stub_instruction_definition, stub_deserialized_instruction(accounts: { info: "info_address" }))

      expect(hotspot_syncer).to have_received(:sync_hotspot).with("asset_id_789")
    end
  end

  private

  define_method(:stub_hotspot_syncer) do
    instance_spy(Relay::Helium::L2::HotspotSyncer)
  end

  define_method(:stub_program_client) do |accounts|
    instance_double(Relay::Solana::ProgramClient).tap do |client|
      accounts.each_pair do |account, data|
        allow(client).to receive(:get_and_deserialize_account).with(account).and_return(data)
      end
    end
  end

  define_method(:stub_instruction_definition) do
    instance_double(Relay::Solana::Idl::InstructionDefinition)
  end

  define_method(:stub_deserialized_instruction) do |accounts:|
    instance_double(
      Relay::Solana::Idl::InstructionDefinition::DeserializedInstruction,
      accounts: accounts
    )
  end
end
