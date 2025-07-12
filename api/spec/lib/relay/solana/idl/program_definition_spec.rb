# typed: false

RSpec.describe Relay::Solana::Idl::ProgramDefinition do
  # TODO: write proper unit tests for the entire module

  it "can be instantiated for the Helium Entity Manager IDL" do
    expect { build_definition }.not_to raise_error
  end

  describe "#find_account_from_data" do
    it "finds the account definition from the account data" do
      account_data = Base64.decode64(<<~BASE64.gsub("\n", ""))
        YcRnkrAhR+uASMg27q/FAqfNGU27Y8tTrHSkqhR391tDK05StOuxueAvMKXYnHMOPNmNAFgBQrvT6la5B66nSBxZ/G7MqZOXBwAAAExpbnhkb3T+
        8qPMkcJRPtkCH25kmUFdaHDU1sXlAbrnIDGs69XfeQF4nSbMmTuPDSUBJm9LvxsWsgg36q20sjbgd80T589gdf+ae+IX/VId9GuOU3hocsS44WRf
        THr/J//bOAXV9VOeMwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      BASE64

      definition = build_definition
      account = definition.find_account_from_data(account_data)

      expect(account.name).to eq("MakerV0")
    end
  end

  private

  define_method(:build_definition) do
    Relay::Solana::Idl::ProgramDefinition.from_file(Rails.root.join("data/idls/helium-entity-manager.json"))
  end
end
