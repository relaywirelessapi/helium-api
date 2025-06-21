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
end
