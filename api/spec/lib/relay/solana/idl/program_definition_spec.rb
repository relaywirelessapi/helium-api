RSpec.describe Relay::Solana::Idl::ProgramDefinition do
  # TODO: write proper unit tests for the entire module

  it "can be instantiated for the Helium Entity Manager IDL" do
    expect {
      Relay::Solana::Idl::ProgramDefinition.from_file(Rails.root.join("data/idls/helium-entity-manager.json"))
    }.not_to raise_error
  end
end
