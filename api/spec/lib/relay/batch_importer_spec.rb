# typed: false

RSpec.describe Relay::BatchImporter do
  describe "#import" do
    it "adds a deduplication key to each row" do
      model_klass = stub_model_klass(columns: [ "name" ])
      deduplicator = stub_deduplicator(deduplication_key: "deduplication_key")
      importer = build_importer(deduplicator: deduplicator)

      importer.import(model_klass, [ { name: "Item 1" } ])

      expect(model_klass).to have_received(:import).with([
        a_hash_including(name: "Item 1", deduplication_key: "deduplication_key")
      ], on_duplicate_key_ignore: true)
    end

    context "when rows contain keys that don't match model columns" do
      it "filters out unknown columns" do
        model_klass = stub_model_klass(columns: [ "id", "name", "description", "created_at" ])

        batch_importer = Relay::BatchImporter.new
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

        batch_importer = Relay::BatchImporter.new
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

  def stub_model_klass(columns: [])
    class_spy(ApplicationRecord, column_names: columns)
  end

  def build_importer(deduplicator: stub_deduplicator)
    Relay::BatchImporter.new(deduplicator: deduplicator)
  end

  def stub_deduplicator(deduplication_key: SecureRandom.uuid)
    instance_double(Relay::Deduplicator).tap do |deduplicator|
      allow(deduplicator).to receive(:calculate_deduplication_key).with(any_args).and_return(deduplication_key)
    end
  end
end
