# typed: false

FactoryBot.define do
  factory :helium_l2_iot_witness_ingest_report, class: "Relay::Helium::L2::IotWitnessIngestReport" do
    transient do
      file { create(:helium_l2_file) }
    end

    received_at { Time.current }
    hotspot_key { "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N" }
    data { "test_data" }
    reported_at { Time.current }
    tmst { 123456 }
    signal { -80 }
    snr { 5 }
    frequency { 915 }
    data_rate { "SF10BW125" }
    signature { "test_signature" }
    file_category { file.category }
    file_name { file.name }
    deduplication_key { SecureRandom.uuid }
  end
end
