# typed: false

require_dependency Rails.root.join("vendor/helium-protobuf/reward_manifest_pb")

RSpec.describe Relay::Helium::L2::Deserializers::RewardManifestDeserializer do
  it "deserializes a mobile reward manifest message and imports it into the database" do
    message = Helium::Reward_manifest.encode(Helium::Reward_manifest.new(
      written_files: [ "file1", "file2" ],
      start_timestamp: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
      end_timestamp: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
      epoch: 100,
      price: 150,
      mobile_reward_data: Helium::Mobile_reward_data.new(
        poc_bones_per_reward_share: Helium::Decimal.new(value: "100"),
        boosted_poc_bones_per_reward_share: Helium::Decimal.new(value: "150"),
        service_provider_promotions: [
          Helium::Service_provider_promotions.new(
            service_provider: :helium_mobile,
            incentive_escrow_fund_bps: 1000,
            promotions: [
              Helium::Service_provider_promotions::Promotion.new(
                entity: "test_entity",
                start_ts: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
                end_ts: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
                shares: 200
              )
            ]
          )
        ],
        token: :mobile_reward_token_hnt
      )
    ))

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    reward_manifest = Relay::Helium::L2::RewardManifest.first
    expect(reward_manifest).to have_attributes(
      written_files: [ "file1", "file2" ],
      start_timestamp: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
      end_timestamp: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
      epoch: 100,
      price: 150,
      reward_data: {
        "reward_type" => "mobile",
        "poc_bones_per_reward_share" => "100",
        "boosted_poc_bones_per_reward_share" => "150",
        "service_provider_promotions" => [
          {
            "service_provider" => "helium_mobile",
            "incentive_escrow_fund_bps" => 1000,
            "promotions" => [
              {
                "entity" => "test_entity",
                "start_ts" => Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
                "end_ts" => Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
                "shares" => 200
              }
            ]
          }
        ],
        "token" => "mobile_reward_token_hnt"
      },
      file_category: "test_category",
      file_name: "test_file"
    )

    expect(reward_manifest.files.count).to eq(2)
    expect(reward_manifest.files.pluck(:file_name)).to match_array([ "file1", "file2" ])
  end

  it "deserializes an IoT reward manifest message and imports it into the database" do
    message = Helium::Reward_manifest.encode(Helium::Reward_manifest.new(
      written_files: [ "file1", "file2" ],
      start_timestamp: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
      end_timestamp: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
      epoch: 100,
      price: 150,
      iot_reward_data: Helium::Iot_reward_data.new(
        poc_bones_per_beacon_reward_share: Helium::Decimal.new(value: "100"),
        poc_bones_per_witness_reward_share: Helium::Decimal.new(value: "50"),
        dc_bones_per_share: Helium::Decimal.new(value: "20"),
        token: :iot_reward_token_iot
      )
    ))

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    reward_manifest = Relay::Helium::L2::RewardManifest.first
    expect(reward_manifest).to have_attributes(
      written_files: [ "file1", "file2" ],
      start_timestamp: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
      end_timestamp: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
      epoch: 100,
      price: 150,
      reward_data: {
        "reward_type" => "iot",
        "poc_bones_per_beacon_reward_share" => "100",
        "poc_bones_per_witness_reward_share" => "50",
        "dc_bones_per_share" => "20",
        "token" => "iot_reward_token_iot"
      },
      file_category: "test_category",
      file_name: "test_file"
    )

    expect(reward_manifest.files.count).to eq(2)
    expect(reward_manifest.files.pluck(:file_name)).to match_array([ "file1", "file2" ])
  end
end
