# typed: false

RSpec.describe Relay::Helium::L2::ScheduleFileDefinitionPullsJob do
  it "schedules a PullFilesForDefinitionJob for each file definition" do
    allow(Relay::Helium::L2::FileDefinition).to receive(:all).and_return([
      stub_file_definition(id: "category1/prefix1"),
      stub_file_definition(id: "category2/prefix2")
    ])

    described_class.perform_now

    aggregate_failures do
      expect(Relay::Helium::L2::PullFilesForDefinitionJob).to have_been_enqueued.with("category1/prefix1")
      expect(Relay::Helium::L2::PullFilesForDefinitionJob).to have_been_enqueued.with("category2/prefix2")
    end
  end

  private

  def stub_file_definition(id:)
    instance_double(Relay::Helium::L2::FileDefinition, id: id)
  end
end
