# typed: false

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_mobile_pb")

RSpec.describe Relay::Helium::L2::Deserializers::MobileRewardShareDeserializer do
  it "deserializes a radio_reward message and imports it into the database" do
    message = Helium::PocMobile::Mobile_reward_share.encode(
      Helium::PocMobile::Mobile_reward_share.new(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        radio_reward: Helium::PocMobile::Radio_reward.new(
          hotspot_key: "\x00\xEF\xFF\xB8#\x8EU\x13\xE60c\xD8\x13\xCB\xF5\xE7!$r?\xACxx~\x8EDN\x04\xB0\xCD\x10\x17R".force_encoding("ASCII-8BIT"),
          cbsd_id: "test_cbsd_id",
          dc_transfer_reward: 1 * 10**6,
          poc_reward: 2 * 10**6
        )
      )
    )

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    expect(Relay::Helium::L2::MobileRewardShare.all).to match_array([
      have_attributes(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
        reward_type: "radio_reward",
        hotspot_key: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
        cbsd_id: "test_cbsd_id",
        dc_transfer_reward: 1 * 10**6,
        poc_reward: 2 * 10**6,
        file_category: "test_category",
        file_name: "test_file"
      )
    ])
  end

  it "deserializes a gateway_reward message and imports it into the database" do
    message = Helium::PocMobile::Mobile_reward_share.encode(
      Helium::PocMobile::Mobile_reward_share.new(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        gateway_reward: Helium::PocMobile::Gateway_reward.new(
          hotspot_key: "\x00\xEF\xFF\xB8#\x8EU\x13\xE60c\xD8\x13\xCB\xF5\xE7!$r?\xACxx~\x8EDN\x04\xB0\xCD\x10\x17R".force_encoding("ASCII-8BIT"),
          dc_transfer_reward: 1 * 10**6
        )
      )
    )

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    expect(Relay::Helium::L2::MobileRewardShare.all).to match_array([
      have_attributes(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
        reward_type: "gateway_reward",
        hotspot_key: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
        dc_transfer_reward: 1 * 10**6,
        file_category: "test_category",
        file_name: "test_file"
      )
    ])
  end

  it "deserializes a subscriber_reward message and imports it into the database" do
    message = Helium::PocMobile::Mobile_reward_share.encode(
      Helium::PocMobile::Mobile_reward_share.new(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        subscriber_reward: Helium::PocMobile::Subscriber_reward.new(
          subscriber_id: "\x00\xEF\xFF\xB8#\x8EU\x13\xE60c\xD8\x13\xCB\xF5\xE7!$r?\xACxx~\x8EDN\x04\xB0\xCD\x10\x17R".force_encoding("ASCII-8BIT"),
          discovery_location_amount: 1 * 10**6
        )
      )
    )

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    expect(Relay::Helium::L2::MobileRewardShare.all).to match_array([
      have_attributes(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
        reward_type: "subscriber_reward",
        subscriber_id: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
        discovery_location_amount: 1 * 10**6,
        file_category: "test_category",
        file_name: "test_file"
      )
    ])
  end

  it "deserializes a service_provider_reward message and imports it into the database" do
    message = Helium::PocMobile::Mobile_reward_share.encode(
      Helium::PocMobile::Mobile_reward_share.new(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        service_provider_reward: Helium::PocMobile::Service_provider_reward.new(
          service_provider_id: :helium_mobile,
          amount: 1 * 10**6
        )
      )
    )

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    expect(Relay::Helium::L2::MobileRewardShare.all).to match_array([
      have_attributes(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
        reward_type: "service_provider_reward",
        service_provider_id: "helium_mobile",
        amount: 1 * 10**6,
        file_category: "test_category",
        file_name: "test_file"
      )
    ])
  end

  it "deserializes a radio_reward_v2 message and imports it into the database" do
    message = Helium::PocMobile::Mobile_reward_share.encode(
      Helium::PocMobile::Mobile_reward_share.new(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        radio_reward_v2: Helium::PocMobile::Radio_reward_v2.new(
          hotspot_key: "\x00\xEF\xFF\xB8#\x8EU\x13\xE60c\xD8\x13\xCB\xF5\xE7!$r?\xACxx~\x8EDN\x04\xB0\xCD\x10\x17R".force_encoding("ASCII-8BIT"),
          cbsd_id: "test_cbsd_id",
          base_coverage_points_sum: Helium::Decimal.new(value: "100"),
          boosted_coverage_points_sum: Helium::Decimal.new(value: "200"),
          base_reward_shares: Helium::Decimal.new(value: "300"),
          boosted_reward_shares: Helium::Decimal.new(value: "400"),
          base_poc_reward: 1 * 10**6,
          boosted_poc_reward: 2 * 10**6,
          seniority_timestamp: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
          coverage_object: "test_coverage_object",
          location_trust_score_multiplier: Helium::Decimal.new(value: "1.5"),
          speedtest_multiplier: Helium::Decimal.new(value: "2.0"),
          sp_boosted_hex_status: :sp_boosted_hex_status_eligible,
          oracle_boosted_hex_status: :oracle_boosted_hex_status_banned
        )
      )
    )

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    expect(Relay::Helium::L2::MobileRewardShare.all).to match_array([
      have_attributes(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
        reward_type: "radio_reward_v2",
        hotspot_key: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
        cbsd_id: "test_cbsd_id",
        base_coverage_points_sum: 100.0,
        boosted_coverage_points_sum: 200.0,
        base_reward_shares: 300.0,
        boosted_reward_shares: 400.0,
        base_poc_reward: 1 * 10**6,
        boosted_poc_reward: 2 * 10**6,
        seniority_timestamp: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        coverage_object: "test_coverage_object",
        location_trust_score_multiplier: 1.5,
        speedtest_multiplier: 2.0,
        sp_boosted_hex_status: "sp_boosted_hex_status_eligible",
        oracle_boosted_hex_status: "oracle_boosted_hex_status_banned",
        file_category: "test_category",
        file_name: "test_file"
      )
    ])
  end

  it "deserializes a promotion_reward message and imports it into the database" do
    message = Helium::PocMobile::Mobile_reward_share.encode(
      Helium::PocMobile::Mobile_reward_share.new(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        promotion_reward: Helium::PocMobile::Promotion_reward.new(
          entity: "test_entity",
          service_provider_amount: 1 * 10**6,
          matched_amount: 2 * 10**6
        )
      )
    )

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    expect(Relay::Helium::L2::MobileRewardShare.all).to match_array([
      have_attributes(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
        reward_type: "promotion_reward",
        entity: "test_entity",
        service_provider_amount: 1 * 10**6,
        matched_amount: 2 * 10**6,
        file_category: "test_category",
        file_name: "test_file"
      )
    ])
  end

  it "deserializes an unallocated_reward message and imports it into the database" do
    message = Helium::PocMobile::Mobile_reward_share.encode(
      Helium::PocMobile::Mobile_reward_share.new(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
        unallocated_reward: Helium::PocMobile::Unallocated_reward.new(
          amount: 1 * 10**6
        )
      )
    )

    file = create(:helium_l2_file, category: "test_category", name: "test_file")

    deserializer = described_class.new
    deserialized_data = deserializer.deserialize(message, file: file)
    deserializer.import([ deserialized_data ])

    expect(Relay::Helium::L2::MobileRewardShare.all).to match_array([
      have_attributes(
        start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
        end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
        reward_type: "unallocated_reward",
        unallocated_reward_type: "unallocated_reward_type_poc",
        amount: 1 * 10**6,
        file_category: "test_category",
        file_name: "test_file"
      )
    ])
  end
end
