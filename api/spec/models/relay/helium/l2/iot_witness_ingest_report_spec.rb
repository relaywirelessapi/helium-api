# typed: false

RSpec.describe Relay::Helium::L2::IotWitnessIngestReport do
  it "has a valid factory" do
    expect(create(:helium_l2_iot_witness_ingest_report)).to be_valid
  end
end
