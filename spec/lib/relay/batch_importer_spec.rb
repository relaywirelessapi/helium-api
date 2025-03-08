# typed: false

RSpec.describe Relay::BatchImporter do
  describe "#import" do
    context "when rows contain keys that don't match model columns" do
      it "filters out unknown columns" do
        model_klass = stub_model_klass(columns: [ "id", "name", "created_at" ])

        batch_importer = Relay::BatchImporter.new
        batch_importer.import(model_klass, [
          { id: 1, name: "Item 1", unknown_field: "value" },
          { id: 2, name: "Item 2" }
        ])

        expect(model_klass).to have_received(:import).with([
          a_hash_including(id: 1, name: "Item 1", created_at: nil),
          a_hash_including(id: 2, name: "Item 2", created_at: nil)
        ], on_duplicate_key_ignore: true)
      end
    end

    context "when rows are missing some model columns" do
      it "includes all model columns with nil values for missing fields" do
        model_klass = stub_model_klass(columns: [ "id", "name", "created_at" ])

        batch_importer = Relay::BatchImporter.new
        batch_importer.import(model_klass, [
          { id: 1 },
          { name: "Item 2" }
        ])

        expect(model_klass).to have_received(:import).with([
          a_hash_including(id: 1, name: nil, created_at: nil),
          a_hash_including(id: nil, name: "Item 2", created_at: nil)
        ], on_duplicate_key_ignore: true)
      end
    end
  end

  private

  def stub_model_klass(columns: [])
    class_spy(ApplicationRecord, column_names: columns)
  end
end
