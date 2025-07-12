# typed: false

RSpec.describe Relay::Helium::L2::InitializeHotspotsJob do
  it "enqueues hotpsot initialization for each maker" do
    maker = create(:helium_l2_maker)

    described_class.perform_now

    expect(Relay::Helium::L2::InitializeHotspotsForMakerJob).to have_been_enqueued.with(maker)
  end
end
