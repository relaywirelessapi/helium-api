# typed: false

RSpec.describe Relay::Helium::L2::IotBeaconIngestReport do
  it "has a valid factory" do
    expect(create(:helium_l2_iot_beacon_ingest_report)).to be_valid
  end
end
