# typed: false

require_dependency Rails.root.join("vendor/helium-protobuf/service/poc_lora_pb")

RSpec.describe Relay::Helium::L2::Deserializers::IotRewardShareDeserializer do
  describe "#decode" do
    context "with a gateway_reward" do
      it "returns a hash" do
        message = Helium::PocLora::Iot_reward_share.encode(Helium::PocLora::Iot_reward_share.new(
          start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
          end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
          gateway_reward: Helium::PocLora::Gateway_reward.new(
            hotspot_key: "\x00\xEF\xFF\xB8#\x8EU\x13\xE60c\xD8\x13\xCB\xF5\xE7!$r?\xACxx~\x8EDN\x04\xB0\xCD\x10\x17R".force_encoding("ASCII-8BIT"),
            dc_transfer_amount: 1 * 10**6,
            witness_amount: 2 * 10**6,
            beacon_amount: 3 * 10**6
          )
        ))

        record = build_deserializer.deserialize(message)

        expect(record).to eq(
          start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
          end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
          reward_type: :gateway_reward,
          hotspot_key: "112phT6PPtLyQqkdnMppgWrTwdDpzzz2C7Q7agHQMhgpiPfsUh5N",
          dc_transfer_amount: 1 * 10**6,
          witness_amount: 2 * 10**6,
          beacon_amount: 3 * 10**6
        )
      end
    end

    context "with an operational_reward" do
      it "returns a hash" do
        message = Helium::PocLora::Iot_reward_share.encode(Helium::PocLora::Iot_reward_share.new(
          start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
          end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
          operational_reward: Helium::PocLora::Operational_reward.new(
            amount: 1 * 10**6
          )
        ))

        record = build_deserializer.deserialize(message)

        expect(record).to eq(
          start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
          end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
          reward_type: :operational_reward,
          amount: 1 * 10**6
        )
      end
    end

    context "with an unallocated_reward" do
      it "returns a hash" do
        message = Helium::PocLora::Iot_reward_share.encode(Helium::PocLora::Iot_reward_share.new(
          start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
          end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00").to_i,
          unallocated_reward: Helium::PocLora::Unallocated_reward.new(
            reward_type: "unallocated_reward_type_poc",
            amount: 1 * 10**6
          )
        ))

        record = build_deserializer.deserialize(message)

        expect(record).to eq(
          start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
          end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
          reward_type: :unallocated_reward,
          unallocated_reward_type: :unallocated_reward_type_poc,
          amount: 1 * 10**6
        )
      end
    end
  end

  describe "#import" do
    it "imports the given messages into the DB" do
      batch_importer = stub_batch_importer
      deserializer = build_deserializer(batch_importer: batch_importer)

      deserializer.import([
        {
          start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
          end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
          reward_type: :unallocated_reward,
          unallocated_reward_type: :unallocated_reward_type_poc,
          amount: 1 * 10**6
        }
      ])

      expect(batch_importer).to have_received(:import).with(Relay::Helium::L2::IotRewardShare, [
        {
          start_period: Time.zone.parse("Fri, 27 Jan 2023 20:30:00.000000000 EST -05:00"),
          end_period: Time.zone.parse("Sat, 28 Jan 2023 20:30:00.000000000 EST -05:00"),
          reward_type: :unallocated_reward,
          unallocated_reward_type: :unallocated_reward_type_poc,
          amount: 1 * 10**6
        }
      ])
    end
  end

  private

  def build_deserializer(batch_importer: stub_batch_importer)
    described_class.new(
      base58_encoder: Relay::Base58Encoder.new,
      batch_importer: batch_importer,
    )
  end

  def stub_batch_importer
    instance_spy(Relay::BatchImporter)
  end
end
