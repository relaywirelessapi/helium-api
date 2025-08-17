# typed: false

RSpec.describe Relay::Helium::L1::ImportOrchestrator do
  describe "#each_file" do
    it "yields each file for the given importer" do
      importer = stub_importer(prefix: "blockchain-etl-export/account_inventory/")
      file_parser = stub_file_parser.tap do |parser|
        allow(parser).to receive(:each_file).with("test-bucket", "blockchain-etl-export/account_inventory/")
          .and_yield("file1")
          .and_yield("file2")
      end

      orchestrator = build_orchestrator(bucket: "test-bucket", file_parser: file_parser)

      expect { |b| orchestrator.each_file(importer, &b) }.to yield_successive_args(
        "file1",
        "file2"
      )
    end
  end

  describe "#import_file" do
    it "imports the given file" do
      model_klass = stub_model_klass
      importer = stub_importer(
        model_klass: model_klass,
        prefix: "blockchain-etl-export/account_inventory/",
        parse_row: ->(row) {
          if row[0] == "address"
            nil
          else
            {
              address: row[0],
              balance: row[1].to_i,
              nonce: row[2].to_i
            }
          end
        }
      )
      batch_drainer = stub_batch_drainer
      file_parser = stub_file_parser({
        [ "test-bucket", "blockchain-etl-export/account_inventory/file1" ] => [
          [ "address", "balance", "nonce" ],
          [ "address1", "100", "1" ],
          [ "address2", "200", "2" ]
        ]
      })

      import_orchestrator = build_orchestrator(bucket: "test-bucket", batch_size: 1000, file_parser: file_parser)
      import_orchestrator.import_file(importer, "file1")

      aggregate_failures do
        expect(batch_drainer).to have_received(:<<).with({ address: "address1", balance: 100, nonce: 1 })
        expect(batch_drainer).to have_received(:<<).with({ address: "address2", balance: 200, nonce: 2 })
      end
    end
  end

  private

  define_method(:stub_model_klass) do
    class_double(ApplicationRecord)
  end

  define_method(:stub_importer) do |prefix: "blockchain-etl-export/account_inventory/", model_klass: ApplicationRecord, parse_row: ->(row) { row }|
    instance_double(Relay::Helium::L1::Importers::BaseImporter, prefix:, model_klass:).tap do |importer|
      allow(importer).to receive(:parse_row) { |row| parse_row.call(row) }
    end
  end

  define_method(:stub_file_parser) do |parsed_files = {}|
    instance_double(Relay::Helium::L1::FileParser).tap do |parser|
      parsed_files.each_pair do |(bucket, key), rows|
        mock = allow(parser).to receive(:parse).with(bucket, key)
        rows.each { |row| mock.and_yield(row) }
      end
    end
  end

  define_method(:stub_batch_drainer) do
    instance_spy(Relay::Importing::BatchDrainer).tap do |drainer|
      allow(Relay::Importing::BatchDrainer).to receive(:process).and_yield(drainer)
    end
  end

  define_method(:build_orchestrator) do |bucket: "test-bucket", batch_size: 5000, file_parser: stub_file_parser|
    described_class.new(
      bucket: bucket,
      batch_size: batch_size,
      file_parser: file_parser
    )
  end
end
