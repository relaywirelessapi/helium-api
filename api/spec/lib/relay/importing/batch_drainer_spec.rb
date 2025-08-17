# typed: false

RSpec.describe Relay::Importing::BatchDrainer do
  describe "#<<" do
    it "flushes the batch when it reaches the batch size" do
      model_klass = stub_model_klass
      batch_importer = stub_batch_importer
      drainer = build_drainer(model_klass: model_klass, batch_size: 2, batch_importer: batch_importer)

      drainer << { name: "Item 1" }
      drainer << { name: "Item 2" }

      expect(batch_importer).to have_received(:import).with(model_klass, [
        { name: "Item 1" },
        { name: "Item 2" }
      ])
    end

    it "does not flush when batch size is not reached" do
      batch_importer = stub_batch_importer
      model_klass = stub_model_klass
      drainer = build_drainer(model_klass: model_klass, batch_size: 3, batch_importer: batch_importer)

      drainer << { name: "Item 1" }
      drainer << { name: "Item 2" }

      expect(batch_importer).not_to have_received(:import)
    end
  end

  describe "#flush" do
    it "imports the current batch and clears it" do
      batch_importer = stub_batch_importer
      model_klass = stub_model_klass
      drainer = build_drainer(model_klass: model_klass, batch_importer: batch_importer)
      drainer << { name: "Item 1" }
      drainer << { name: "Item 2" }

      drainer.flush

      expect(batch_importer).to have_received(:import).with(model_klass, [
        { name: "Item 1" },
        { name: "Item 2" }
      ])
    end

    it "starts garbage collection after flushing" do
      stub_const("GC", class_spy(GC))
      model_klass = stub_model_klass
      batch_importer = stub_batch_importer
      drainer = build_drainer(model_klass: model_klass, batch_importer: batch_importer)

      drainer << { name: "Item 1" }
      drainer.flush

      expect(GC).to have_received(:start)
    end
  end

  describe ".process" do
    it "creates a drainer, yields it to the block, and flushes automatically" do
      model_klass = stub_model_klass
      batch_importer = stub_batch_importer
      batch_size = 2

      described_class.process(
        model_klass: model_klass,
        batch_size: batch_size,
        batch_importer: batch_importer
      ) do |drainer|
        drainer << { name: "Item 1" }
        drainer << { name: "Item 2" }
        drainer << { name: "Item 3" }
      end

      aggregate_failures do
        expect(batch_importer).to have_received(:import).with(model_klass, [
          { name: "Item 1" },
          { name: "Item 2" }
        ])
        expect(batch_importer).to have_received(:import).with(model_klass, [
          { name: "Item 3" }
        ])
      end
    end
  end

  private

  define_method(:stub_model_klass) do
    class_spy(ApplicationRecord)
  end

  define_method(:stub_batch_importer) do
    instance_spy(Relay::Importing::BatchImporter)
  end

  define_method(:build_drainer) do |model_klass: stub_model_klass, batch_size: 100, batch_importer: stub_batch_importer|
    described_class.new(
      model_klass: model_klass,
      batch_size: batch_size,
      batch_importer: batch_importer
    )
  end
end
