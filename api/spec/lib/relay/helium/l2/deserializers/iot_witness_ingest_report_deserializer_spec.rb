# typed: false

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_lora_pb")

RSpec.describe Relay::Helium::L2::Deserializers::IotWitnessIngestReportDeserializer do
  describe "#deserialize" do
    it "returns a hash with the decoded message data" do
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

      record = build_deserializer.deserialize(message)

      expect(record).to eq(
        received_timestamp: Time.zone.at(1674864600),
        pub_key: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
        data: "test_data",
        timestamp: Time.zone.at(1674864600),
        tmst: 123456,
        signal: -80,
        snr: 5,
        frequency: 915,
        datarate: :SF10BW125,
        signature: "test_signature"
      )
    end
  end

  describe "#import" do
    it "imports the given messages into the DB" do
      batch_importer = stub_batch_importer
      deserializer = build_deserializer(batch_importer: batch_importer)

      messages = [ {
        received_timestamp: Time.zone.at(1674864600),
        pub_key: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
        data: "test_data",
        timestamp: Time.zone.at(1674864600),
        tmst: 123456,
        signal: -80,
        snr: 5.5,
        frequency: 915.0,
        datarate: "SF10BW125",
        signature: "test_signature"
      } ]

      deserializer.import(messages)

      expect(batch_importer).to have_received(:import).with(
        Relay::Helium::L2::IotWitnessIngestReport,
        messages
      )
    end
  end

  private

  def build_deserializer(batch_importer: stub_batch_importer)
    described_class.new(
      base58_encoder: Relay::Base58Encoder.new,
      batch_importer: batch_importer
    )
  end

  def stub_batch_importer
    instance_spy(Relay::BatchImporter)
  end
end
