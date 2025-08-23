# typed: false

RSpec.describe Relay::Helium::L1::ImportFilesJob do
  context "when there are unprocessed files" do
    it "imports all unprocessed files" do
      create_file(file_name: "file1.csv.gz")
      create_file(file_name: "file2.csv.gz")
      orchestrator = stub_orchestrator

      described_class.perform_now

      aggregate_failures do
        expect(orchestrator).to have_received(:import_file).with(any_args, "file1.csv.gz")
        expect(orchestrator).to have_received(:import_file).with(any_args, "file2.csv.gz")
      end
    end

    it "marks all files as processed" do
      freeze_time do
        file1 = create_file
        file2 = create_file
        stub_orchestrator

        described_class.perform_now

        aggregate_failures do
          expect(file1.reload).to have_attributes(processed_at: Time.current)
          expect(file2.reload).to have_attributes(processed_at: Time.current)
        end
      end
    end
  end

  define_method(:create_file) do |**attributes|
    create(:helium_l1_file, **attributes)
  end

  define_method(:stub_orchestrator) do
    instance_spy(Relay::Helium::L1::ImportOrchestrator).tap do |o|
      allow(Relay::Helium::L1::ImportOrchestrator).to receive(:new).and_return(o)
    end
  end
end
