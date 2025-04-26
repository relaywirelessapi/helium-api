# typed: false

RSpec.describe Relay::BatchImporter do
  describe "#import" do
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

    context "when rows contain binary data" do
      it "converts binary data to Base64 before generating deduplication key" do
        model_klass = stub_model_klass(columns: [ "id", "name", "data" ])
        binary_data = "\x00\x01\x02\x03".force_encoding("ASCII-8BIT")

        batch_importer = Relay::BatchImporter.new
        batch_importer.import(model_klass, [
          { name: "Item 1", data: binary_data }
        ])

        expect(model_klass).to have_received(:import).with([
          a_hash_including(
            name: "Item 1",
            data: binary_data,
            deduplication_key: Digest::MD5.hexdigest({ name: "Item 1", data: Base64.strict_encode64(binary_data) }.sort.to_h.to_json)
          )
        ], on_duplicate_key_ignore: true)
      end
    end
  end

  private

  def stub_model_klass(columns: [])
    class_spy(ApplicationRecord, column_names: columns)
  end
end
