# typed: false

RSpec.describe Relay::Helium::L2::ProcessFileJob do
  it "processes the oracle file using FileProcessor" do
    oracle_file = build_stubbed(:helium_l2_file)
    processor = stub_file_processor

    described_class.perform_now(oracle_file)

    expect(processor).to have_received(:process).with(oracle_file)
  end
end

private

def stub_file_processor
  processor = instance_spy(Relay::Helium::L2::FileProcessor)
  allow(Relay::Helium::L2::FileProcessor).to receive(:new).and_return(processor)
  processor
end

def stub_file_definition(id: "test-category/test-prefix", bucket: "test-bucket", category: "test-category", prefix: "test-prefix")
  instance_double(
    Relay::Helium::L2::FileDefinition,
    id: id,
    bucket: bucket,
    category: category,
    prefix: prefix
  )
end
