# typed: false

RSpec.describe Relay::Helium::L2::InitializeHotspotsForMakerJob do
  it "enqueues sync jobs for each asset in the maker's collection" do
    maker = create(:helium_l2_maker, collection: "test_collection")
    hotspot_syncer = instance_double(Relay::Helium::L2::HotspotSyncer, list_hotspots_for_maker: [
      { "id" => "asset_1" },
      { "id" => "asset_2" },
      { "id" => "asset_3" }
    ])
    allow(Relay::Helium::L2::HotspotSyncer).to receive(:new).and_return(hotspot_syncer)

    described_class.perform_now(maker)

    aggregate_failures do
      expect(Relay::Helium::L2::SyncHotspotJob).to have_been_enqueued.with("asset_1")
      expect(Relay::Helium::L2::SyncHotspotJob).to have_been_enqueued.with("asset_2")
      expect(Relay::Helium::L2::SyncHotspotJob).to have_been_enqueued.with("asset_3")
    end
  end
end
