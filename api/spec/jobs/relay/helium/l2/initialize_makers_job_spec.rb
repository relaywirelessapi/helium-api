# typed: false

RSpec.describe Relay::Helium::L2::InitializeMakersJob do
  it "enqueues the sync of each maker" do
    maker_syncer = instance_double(Relay::Helium::L2::MakerSyncer, list_makers: [
      { "pubkey" => "address", "account" => { "data" => [ "base64_encoded_data" ] } }
    ])
    allow(Relay::Helium::L2::MakerSyncer).to receive(:new).and_return(maker_syncer)

    described_class.perform_now

    expect(Relay::Helium::L2::SyncMakerJob).to have_been_enqueued.with("address", "base64_encoded_data")
  end
end
