# typed: false

RSpec.describe Relay::Helium::L1::FileParser do
  describe "#each_file" do
    it "yields each file in the given bucket with the given prefix" do
      file_client = stub_file_client.tap do |client|
        mock_each_object = allow(client).to receive(:each_object).with(
          bucket: "test-bucket",
          prefix: "data/2024/01/"
        )

        [
          double("object1", key: "data/2024/01/file1.csv.gz"),
          double("object2", key: "data/2024/01/file2.csv.gz"),
          double("object3", key: "data/2024/01/other.txt"),
          double("object4", key: "data/2024/01/file3.csv.gz")
        ].each do |object|
          mock_each_object.and_yield(object)
        end
      end

      parser = described_class.new(file_client: file_client)

      expect { |block| parser.each_file("test-bucket", "data/2024/01/", &block) }.to yield_successive_args(
        "file1.csv.gz",
        "file2.csv.gz",
        "file3.csv.gz"
      )
    end
  end

  describe "#parse" do
    it "decompresses and parses the gzipped CSV file" do
      data = create_gzipped_csv(<<~CSV)
        value1,value2,value3
        value4,value5,value6
      CSV
      file_client = stub_file_client({
        [ "test-bucket", "test-file.csv.gz" ] => data
      })

      parser = described_class.new(file_client: file_client)

      expect { |block| parser.parse("test-bucket", "test-file.csv.gz", &block) }.to yield_successive_args(
        [ "value1", "value2", "value3" ],
        [ "value4", "value5", "value6" ]
      )
    end
  end

  private

  define_method(:create_gzipped_csv) do |content|
    gz = StringIO.new

    Zlib::GzipWriter.new(gz).tap do |writer|
      writer.write(content)
      writer.close
    end

    gz.string
  end

  define_method(:stub_file_client) do |files = {}|
    instance_double(Relay::Helium::FileClient).tap do |client|
      files.each do |(bucket, key), body|
        allow(client).to receive(:get_object).with(
          bucket: bucket,
          key: key,
          response_target: anything
        ) do |args|
          File.write(args[:response_target], body)
          double(Seahorse::Client::Response, body: StringIO.new(body))
        end
      end
    end
  end
end
