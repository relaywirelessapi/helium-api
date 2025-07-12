# typed: false

RSpec.describe Relay::Helium::L2::SyncMakerJob do
  it "calls the maker syncer" do
    maker_syncer = instance_spy(Relay::Helium::L2::MakerSyncer)
    allow(Relay::Helium::L2::MakerSyncer).to receive(:new).and_return(maker_syncer)

    described_class.perform_now("address", Base64.encode64("data"))

    expect(maker_syncer).to have_received(:deserialize_and_sync_maker).with("address", "data")
  end
end
