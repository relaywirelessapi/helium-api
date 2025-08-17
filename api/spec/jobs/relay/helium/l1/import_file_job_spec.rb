# typed: false

RSpec.describe Relay::Helium::L1::ImportFileJob do
  context "when the file has not been imported" do
    it "imports the file" do
      importer = stub_importer
      file = create_file(importer: importer)
      orchestrator = stub_orchestrator

      described_class.perform_now(file)

      expect(orchestrator).to have_received(:import_file).with(importer, file.file_name)
    end

    it "marks the file as imported" do
      freeze_time do
        file = create_file
        stub_orchestrator

        described_class.perform_now(file)

        expect(file).to have_attributes(processed_at: Time.current)
      end
    end
  end

  context "when the file has already been imported" do
    it "does not import the file" do
      file = create_file(processed_at: Time.current)
      orchestrator = stub_orchestrator

      described_class.perform_now(file)

      expect(orchestrator).not_to have_received(:import_file)
    end
  end

  define_method(:stub_importer) do
    instance_double(Relay::Helium::L1::Importers::BaseImporter)
  end

  define_method(:create_file) do |importer: stub_importer, **attributes|
    create(:helium_l1_file, **attributes).tap do |file|
      allow(file).to receive(:importer).and_return(importer)
    end
  end

  define_method(:stub_orchestrator) do
    instance_spy(Relay::Helium::L1::ImportOrchestrator).tap do |o|
      allow(Relay::Helium::L1::ImportOrchestrator).to receive(:new).and_return(o)
    end
  end
end
