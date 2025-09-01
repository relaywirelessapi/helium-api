# typed: false

RSpec.describe Relay::Helium::L1::InitializeFilesJob do
  it "creates file records for each file type and file key" do
    importer = instance_double(Relay::Helium::L1::Importers::BaseImporter)
    importer_klass = class_double(Relay::Helium::L1::Importers::BaseImporter, new: importer)
    stub_const("Relay::Helium::L1::File::IMPORTER_KLASSES", { "accounts" => importer_klass })
    instance_double(Relay::Helium::L1::ImportOrchestrator).tap do |orchestrator|
      allow(orchestrator).to receive(:each_file).with(importer).and_yield("data_xaa.csv.gz")
      allow(Relay::Helium::L1::ImportOrchestrator).to receive(:new).and_return(orchestrator)
    end

    described_class.perform_now

    expect(Relay::Helium::L1::File.all).to match_array([
      have_attributes(
        file_type: "accounts",
        file_name: "data_xaa.csv.gz"
      )
    ])
  end
end
