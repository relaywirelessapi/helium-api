# typed: false

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_lora_pb")

RSpec.describe Relay::Helium::L2::Deserializers::IotRewardShareDeserializer do
  it "deserializes a message and imports it into the database" do
    message = Helium::PocLora::Iot_reward_share.encode(
      Helium::PocLora::Iot_reward_share.new(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        gateway_reward: Helium::PocLora::Gateway_reward.new(
          hotspot_key: "\x00\xEF\xFF\xB8#\x8EU\x13\xE60c\xD8\x13\xCB\xF5\xE7!$r?\xACxx~\x8EDN\x04\xB0\xCD\x10\x17R".force_encoding("ASCII-8BIT"),
          dc_transfer_amount: 1 * 10**6,
          witness_amount: 2 * 10**6,
          beacon_amount: 3 * 10**6
        )
      )
    )

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    expect(Relay::Helium::L2::IotRewardShare.all).to match_array([
      have_attributes(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
        reward_type: "gateway_reward",
        hotspot_key: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
        dc_transfer_amount: 1 * 10**6,
        witness_amount: 2 * 10**6,
        beacon_amount: 3 * 10**6,
        file_category: "test_category",
        file_name: "test_file"
      )
    ])
  end
end
