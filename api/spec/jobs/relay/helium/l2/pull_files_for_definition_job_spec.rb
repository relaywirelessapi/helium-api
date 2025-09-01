# typed: false

RSpec.describe Relay::Helium::L2::PullFilesForDefinitionJob do
  it "enqueues a SyncFileContentJob for each synced file" do
    definition = stub_file_definition(id: "test-category/test-prefix")
    oracle_file = create(:helium_l2_file)
    stub_file_puller(definition => [ oracle_file ])

    described_class.perform_now("test-category/test-prefix")

    expect(Relay::Helium::L2::ProcessFileJob).to have_been_enqueued.with(oracle_file)
  end

  private

  define_method(:stub_file_puller) do |files_for_definitions|
    instance_double(Relay::Helium::L2::FilePuller).tap do |puller|
      files_for_definitions.each_pair do |definition, files|
        mock = allow(puller).to receive(:pull_for).with(definition)
        files.each { |file| mock.and_yield(file) }
      end

      allow(Relay::Helium::L2::FilePuller).to receive(:new).and_return(puller)
    end
  end

  define_method(:stub_file_definition) do |id: "test-category/test-prefix"|
    instance_double(Relay::Helium::L2::FileDefinition, id: id).tap do |definition|
      allow(Relay::Helium::L2::FileDefinition).to receive(:find!).with(id).and_return(definition)
    end
  end
end
