# typed: false

RSpec.describe Relay::Helium::L2::SyncHotspotJob, type: :job do
  describe "#perform" do
    it "delegates to HotspotSyncer" do
      hotspot_syncer = instance_double(Relay::Helium::L2::HotspotSyncer).tap do |syncer|
        allow(syncer).to receive(:sync_hotspot)
      end

      allow(Relay::Helium::L2::HotspotSyncer).to receive(:new).and_return(hotspot_syncer)

      described_class.perform_now("asset_id")

      expect(hotspot_syncer).to have_received(:sync_hotspot).with("asset_id")
    end
  end
end
