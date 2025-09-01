# typed: false

RSpec.describe "/helium/l2/iot-reward-shares", type: :request do
  describe "GET /" do
    it "returns a list of IoT reward shares" do
      iot_reward_share = create(
        :helium_l2_iot_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
      )

      api_get(helium_l2_iot_reward_shares_path(
        from: Time.zone.yesterday,
        to: Time.zone.tomorrow,
      ))

      expect(parsed_response).to be_paginated_collection.with([ iot_reward_share ])
    end

    it "allows filtering by hotspot key" do
      iot_reward_share = create(
        :helium_l2_iot_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        hotspot_key: "1234567890",
      )
      create(
        :helium_l2_iot_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        hotspot_key: "0987654321",
      )

      api_get(helium_l2_iot_reward_shares_path(
        from: Time.zone.yesterday,
        to: Time.zone.tomorrow,
        hotspot_key: "1234567890",
      ))

      expect(parsed_response).to be_paginated_collection.with([ iot_reward_share ])
    end

    it "allows filtering by reward type" do
      iot_reward_share = create(
        :helium_l2_iot_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        reward_type: "gateway_reward",
      )
      create(
        :helium_l2_iot_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        reward_type: "operational_reward",
      )

      api_get(helium_l2_iot_reward_shares_path(
        from: Time.zone.yesterday,
        to: Time.zone.tomorrow,
        reward_type: "gateway_reward",
      ))

      expect(parsed_response).to be_paginated_collection.with([ iot_reward_share ])
    end
  end

  describe "GET /totals" do
    it "returns aggregated totals for IoT reward shares" do
      create(
        :helium_l2_iot_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        beacon_amount: 100,
        witness_amount: 50,
        dc_transfer_amount: 25,
        amount: 175,
      )
      create(
        :helium_l2_iot_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        beacon_amount: 200,
        witness_amount: 75,
        dc_transfer_amount: 50,
        amount: 325,
      )

      User.with_stubbed_plan("enterprise") do
        api_get(totals_helium_l2_iot_reward_shares_path(
          from: Time.zone.yesterday,
          to: Time.zone.tomorrow,
        ))
      end

      expect(parsed_response).to eq({
        "total_beacon_amount" => 300,
        "total_witness_amount" => 125,
        "total_dc_transfer_amount" => 75,
        "total_amount" => 500
      })
    end
  end
end
