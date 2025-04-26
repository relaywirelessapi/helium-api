# typed: false

RSpec.describe Relay::Helium::L2::FilePuller do
  describe "#pull_for" do
    it "creates a new File record for each processed object" do
      last_pulled_file = stub_oracle_file(category: "test-category/test-prefix", name: "last-file")
      definition = stub_file_definition(
        bucket: "test-bucket",
        category: "test-category",
        prefix: "test-prefix",
        last_pulled_file: last_pulled_file
      )
      file_client = stub_file_client(
        bucket: "test-bucket",
        prefix: "test-category/test-prefix",
        start_after: "test-category/test-prefix/last-file",
        s3_objects: [ stub_s3_object(key: "test-category/test-prefix/file1") ]
      )

      puller = build_file_puller(file_client: file_client)
      puller.pull_for(definition) { |_| }

      expect(Relay::Helium::L2::File.count).to eq(1)
    end

    it "yields each created File record" do
      last_pulled_file = stub_oracle_file(category: "test-category/test-prefix", name: "last-file")
      definition = stub_file_definition(
        bucket: "test-bucket",
        category: "test-category",
        prefix: "test-prefix",
        last_pulled_file: last_pulled_file
      )
      file_client = stub_file_client(
        bucket: "test-bucket",
        prefix: "test-category/test-prefix",
        start_after: "test-category/test-prefix/last-file",
        s3_objects: [
          stub_s3_object(key: "test-category/test-prefix/file1"),
          stub_s3_object(key: "test-category/test-prefix/file2")
        ]
      )

      puller = build_file_puller(file_client: file_client)

      expect { |b| puller.pull_for(definition, &b) }.to yield_successive_args(
        have_attributes(category: "test-category/test-prefix", name: "file1"),
        have_attributes(category: "test-category/test-prefix", name: "file2")
      )
    end
  end

  private

  def build_file_puller(file_client:)
    described_class.new(file_client: file_client)
  end

  def stub_file_client(bucket:, prefix:, start_after: nil, s3_objects: [])
    client = instance_double(Relay::Helium::L2::FileClient)

    allow_method = allow(client).to receive(:each_object)
      .with(bucket: bucket, prefix: prefix, start_after: start_after)

    s3_objects.each do |s3_object|
      allow_method = allow_method.and_yield(s3_object)
    end

    client
  end

  def stub_file_definition(bucket:, category:, prefix:, last_pulled_file: nil)
    instance_double(
      Relay::Helium::L2::FileDefinition,
      bucket:,
      category:,
      prefix:,
      last_pulled_file:,
      id: "#{category}/#{prefix}",
      s3_prefix: "#{category}/#{prefix}",
    )
  end

  def stub_oracle_file(category:, name:)
    instance_double(Relay::Helium::L2::File, category:, name:, s3_key: "#{category}/#{name}")
  end

  def stub_s3_object(key:)
    instance_double(Aws::S3::Types::Object, key:)
  end
end
