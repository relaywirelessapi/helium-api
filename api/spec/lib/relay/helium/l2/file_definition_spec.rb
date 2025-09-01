# typed: false

RSpec.describe Relay::Helium::L2::FileDefinition do
  describe "#s3_prefix" do
    it "returns the category and prefix joined with a slash" do
      file_definition = build_file_definition(category: "test-category", prefix: "test-prefix")

      expect(file_definition.s3_prefix).to eq("test-category/test-prefix")
    end
  end

  describe "#last_pulled_file" do
    it "returns the most recently created file" do
      file_definition = build_file_definition
      file = create(:helium_l2_file,
        definition_id: file_definition.id,
        category: "test",
        name: "key",
        created_at: Time.current
      )
      create(:helium_l2_file,
        definition_id: file_definition.id,
        category: "older",
        name: "key",
        created_at: 1.day.ago
      )

      result = file_definition.last_pulled_file

      expect(result).to eq(file)
    end
  end

  private

  define_method(:build_file_definition) do |id: "test-id", bucket: "test-bucket", category: "test-category", prefix: "test-prefix", deserializer: stub_deserializer|
    described_class.new(
      id: id,
      bucket: bucket,
      category: category,
      prefix: prefix,
      deserializer: deserializer
    )
  end

  define_method(:stub_deserializer) do
    instance_double(Relay::Helium::L2::Deserializers::BaseDeserializer)
  end
end
