# typed: false

RSpec.describe "/helium/l2/mobile-reward-shares", type: :request do
  describe "GET /" do
    it "returns a list of mobile reward shares" do
      mobile_reward_share = create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
      )

      api_get(helium_l2_mobile_reward_shares_path(
        from: Time.zone.yesterday,
        to: Time.zone.tomorrow,
      ))

      expect(parsed_response).to be_paginated_collection.with([ mobile_reward_share ])
    end

    it "allows filtering by hotspot key" do
      mobile_reward_share = create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        hotspot_key: "1234567890",
      )
      create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        hotspot_key: "0987654321",
      )

      api_get(helium_l2_mobile_reward_shares_path(
        from: Time.zone.yesterday,
        to: Time.zone.tomorrow,
        hotspot_key: "1234567890",
      ))

      expect(parsed_response).to be_paginated_collection.with([ mobile_reward_share ])
    end

    it "allows filtering by reward type" do
      mobile_reward_share = create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        reward_type: "gateway_reward",
      )
      create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        reward_type: "operational_reward",
      )

      api_get(helium_l2_mobile_reward_shares_path(
        from: Time.zone.yesterday,
        to: Time.zone.tomorrow,
        reward_type: "gateway_reward",
      ))

      expect(parsed_response).to be_paginated_collection.with([ mobile_reward_share ])
    end
  end

  describe "GET /totals" do
    it "returns aggregated totals for mobile reward shares" do
      create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        dc_transfer_reward: 100,
        poc_reward: 50,
        subscriber_reward: 25,
        discovery_location_amount: 75,
        service_provider_amount: 30,
        matched_amount: 40,
      )
      create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        dc_transfer_reward: 200,
        poc_reward: 75,
        subscriber_reward: 50,
        discovery_location_amount: 125,
        service_provider_amount: 60,
        matched_amount: 80,
      )

      User.with_stubbed_plan("enterprise") do
        api_get(totals_helium_l2_mobile_reward_shares_path(
          from: Time.zone.yesterday,
          to: Time.zone.tomorrow,
        ))
      end

      expect(parsed_response).to eq({
        "total_dc_transfer_reward" => 300,
        "total_poc_reward" => 125,
        "total_subscriber_reward" => 75,
        "total_discovery_location_amount" => 200,
        "total_service_provider_amount" => 90,
        "total_matched_amount" => 120
      })
    end
  end
end
