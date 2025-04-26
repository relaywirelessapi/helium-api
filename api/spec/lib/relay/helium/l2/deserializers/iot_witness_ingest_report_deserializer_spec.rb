# typed: false

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_lora_pb")

RSpec.describe Relay::Helium::L2::Deserializers::IotWitnessIngestReportDeserializer do
  describe "deserialization and import flow" do
    it "deserializes a message and imports it into the database" do
      message = Helium::PocLora::Lora_witness_ingest_report_v1.encode(
        Helium::PocLora::Lora_witness_ingest_report_v1.new(
          received_timestamp: 1674864600000,
          report: Helium::PocLora::Lora_witness_report_req_v1.new(
            pub_key: "\x00\xEF\xFF\xB8#\x8EU\x13\xE60c\xD8\x13\xCB\xF5\xE7!$r?\xACxx~\x8EDN\x04\xB0\xCD\x10\x17R".force_encoding("ASCII-8BIT"),
            data: "test_data",
            timestamp: 1674864600000000000,
            tmst: 123456,
            signal: -80,
            snr: 5,
            frequency: 915,
            datarate: :SF10BW125,
            signature: "test_signature"
          )
        )
      )

      file = create(:helium_l2_file, category: "test_category", name: "test_file")

      deserializer = described_class.new
      deserialized_data = deserializer.deserialize(message, file: file)
      deserializer.import([ deserialized_data ])

      expect(Relay::Helium::L2::IotWitnessIngestReport.all).to match_array([
        have_attributes(
          received_at: Time.zone.at(1674864600),
          hotspot_key: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
          data: "test_data",
          reported_at: Time.zone.at(1674864600),
          tmst: 123456,
          signal: -80,
          snr: 5,
          frequency: 915,
          data_rate: "SF10BW125",
          signature: "test_signature",
          file_category: "test_category",
          file_name: "test_file"
        )
      ])
    end
  end
end
