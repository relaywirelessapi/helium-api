# typed: false

RSpec.describe Relay::Importing::BatchImporter do
  describe "#import" do
    context "when the model has a deduplication key column" do
      it "adds a deduplication key to each row" do
        model_klass = stub_model_klass(columns: [ "name", "deduplication_key" ])
        record_deduplicator = stub_record_deduplicator(deduplication_key: "deduplication_key")
        importer = build_importer(record_deduplicator: record_deduplicator)

        importer.import(model_klass, [ { name: "Item 1" } ])

        expect(model_klass).to have_received(:import).with([
          a_hash_including(name: "Item 1", deduplication_key: "deduplication_key")
        ], on_duplicate_key_ignore: true)
      end
    end

    context "when rows contain keys that don't match model columns" do
      it "filters out unknown columns" do
        model_klass = stub_model_klass(columns: [ "id", "name", "description", "created_at" ])

        batch_importer = described_class.new
        batch_importer.import(model_klass, [
          { name: "Item 1", unknown_field: "value" },
          { name: "Item 2" }
        ])

        expect(model_klass).to have_received(:import).with([
          a_hash_including(name: "Item 1", created_at: nil),
          a_hash_including(name: "Item 2", created_at: nil)
        ], on_duplicate_key_ignore: true)
      end
    end

    context "when rows are missing some model columns" do
      it "includes all model columns with nil values for missing fields" do
        model_klass = stub_model_klass(columns: [ "id", "name", "description", "created_at" ])

        batch_importer = described_class.new
        batch_importer.import(model_klass, [
          { description: "Description 1" },
          { name: "Item 2" }
        ])

        expect(model_klass).to have_received(:import).with([
          a_hash_including(description: "Description 1", name: nil, created_at: nil),
          a_hash_including(description: nil, name: "Item 2", created_at: nil)
        ], on_duplicate_key_ignore: true)
      end
    end
  end

  private

  define_method(:stub_model_klass) do |columns: []|
    class_spy(ApplicationRecord, column_names: columns)
  end

  define_method(:build_importer) do |record_deduplicator: stub_record_deduplicator|
    described_class.new(record_deduplicator: record_deduplicator)
  end

  define_method(:stub_record_deduplicator) do |deduplication_key: SecureRandom.uuid|
    instance_double(Relay::Importing::RecordDeduplicator).tap do |record_deduplicator|
      allow(record_deduplicator).to receive(:calculate_deduplication_key).with(any_args).and_return(deduplication_key)
    end
  end
end
