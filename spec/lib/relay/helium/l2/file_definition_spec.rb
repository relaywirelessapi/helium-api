# typed: false

RSpec.describe Relay::Helium::L2::FileDefinition do
  it "can be serialized and deserialized via GlobalID" do
    file_definition = build_file_definition
    allow(described_class).to receive(:all).and_return([ file_definition ])

    global_id = file_definition.to_global_id
    deserialized = GlobalID::Locator.locate(global_id)

    expect(deserialized).to eq(file_definition)
    expect(deserialized.id).to eq(file_definition.id)
  end

  describe "#id" do
    it "returns the correct id format" do
      file_definition = build_file_definition(category: "test-category", prefix: "test-prefix")

      expect(file_definition.id).to eq("test-category/test-prefix")
    end
  end

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
        s3_key: "test-key",
        created_at: Time.current
      )
      create(:helium_l2_file,
        definition_id: file_definition.id,
        s3_key: "older-key",
        created_at: 1.day.ago
      )

      result = file_definition.last_pulled_file

      expect(result).to eq(file)
    end
  end

  private

  def build_file_definition(bucket: "test-bucket", category: "test-category", prefix: "test-prefix", deserializer: stub_deserializer)
    described_class.new(
      bucket: bucket,
      category: category,
      prefix: prefix,
      deserializer: deserializer
    )
  end

  def stub_deserializer
    instance_double(Relay::Helium::L2::Deserializers::BaseDeserializer)
  end
end
