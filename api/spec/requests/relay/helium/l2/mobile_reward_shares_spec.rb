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
        offloaded_bytes: 100,
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
        offloaded_bytes: 200,
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
        "total_matched_amount" => 120,
        "total_offloaded_bytes" => 300
      })
    end
  end

  describe "GET /daily-totals" do
    it "returns per-day aggregated totals for mobile reward shares" do
      day_one = Time.zone.local(2026, 4, 1, 12, 0, 0)
      day_two = Time.zone.local(2026, 4, 2, 12, 0, 0)

      create(
        :helium_l2_mobile_reward_share,
        start_period: day_one - 1.hour,
        end_period: day_one,
        dc_transfer_reward: 100,
        poc_reward: 50,
        subscriber_reward: 25,
        discovery_location_amount: 75,
        service_provider_amount: 30,
        matched_amount: 40,
        offloaded_bytes: 100,
      )
      create(
        :helium_l2_mobile_reward_share,
        start_period: day_one - 1.hour,
        end_period: day_one,
        dc_transfer_reward: 50,
        poc_reward: 25,
        subscriber_reward: 10,
        discovery_location_amount: 20,
        service_provider_amount: 15,
        matched_amount: 5,
        offloaded_bytes: 50,
      )
      create(
        :helium_l2_mobile_reward_share,
        start_period: day_two - 1.hour,
        end_period: day_two,
        dc_transfer_reward: 200,
        poc_reward: 75,
        subscriber_reward: 50,
        discovery_location_amount: 125,
        service_provider_amount: 60,
        matched_amount: 80,
        offloaded_bytes: 200,
      )

      User.with_stubbed_plan("enterprise") do
        api_get(daily_totals_helium_l2_mobile_reward_shares_path(
          from: day_one - 1.day,
          to: day_two + 1.day,
        ))
      end

      expect(parsed_response).to eq({
        "records" => [
          {
            "day" => "2026-04-01",
            "total_dc_transfer_reward" => 150,
            "total_poc_reward" => 75,
            "total_subscriber_reward" => 35,
            "total_discovery_location_amount" => 95,
            "total_service_provider_amount" => 45,
            "total_matched_amount" => 45,
            "total_offloaded_bytes" => 150
          },
          {
            "day" => "2026-04-02",
            "total_dc_transfer_reward" => 200,
            "total_poc_reward" => 75,
            "total_subscriber_reward" => 50,
            "total_discovery_location_amount" => 125,
            "total_service_provider_amount" => 60,
            "total_matched_amount" => 80,
            "total_offloaded_bytes" => 200
          }
        ]
      })
    end

    it "rejects ranges greater than 366 days" do
      User.with_stubbed_plan("enterprise") do
        api_get(daily_totals_helium_l2_mobile_reward_shares_path(
          from: Time.zone.local(2024, 1, 1),
          to: Time.zone.local(2025, 6, 1),
        ))
      end

      expect(response).to have_http_status(422)
    end

    it "raises FeatureNotAvailableError when aggregate_endpoints is disabled" do
      User.with_stubbed_plan("community") do
        api_get(daily_totals_helium_l2_mobile_reward_shares_path(
          from: Time.zone.yesterday,
          to: Time.zone.tomorrow,
        ))
      end

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /totals-by-service-provider" do
    it "returns aggregated totals grouped by service provider" do
      create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        reward_type: "service_provider_reward",
        service_provider_id: "helium-mobile",
        service_provider_amount: 100,
        matched_amount: 25,
        dc_transfer_reward: 200,
        offloaded_bytes: 500,
      )
      create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        reward_type: "service_provider_reward",
        service_provider_id: "helium-mobile",
        service_provider_amount: 50,
        matched_amount: 15,
        dc_transfer_reward: 100,
        offloaded_bytes: 250,
      )
      create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        reward_type: "promotion_reward",
        service_provider_id: "movistar",
        service_provider_amount: 75,
        matched_amount: 30,
        dc_transfer_reward: 150,
        offloaded_bytes: 300,
      )
      create(
        :helium_l2_mobile_reward_share,
        start_period: Time.zone.yesterday,
        end_period: Time.zone.today,
        reward_type: "gateway_reward",
        service_provider_id: nil,
        dc_transfer_reward: 999,
        offloaded_bytes: 999,
      )

      User.with_stubbed_plan("enterprise") do
        api_get(totals_by_service_provider_helium_l2_mobile_reward_shares_path(
          from: Time.zone.yesterday,
          to: Time.zone.tomorrow,
        ))
      end

      expect(parsed_response).to eq({
        "records" => [
          {
            "service_provider_id" => "helium-mobile",
            "total_service_provider_amount" => 150,
            "total_matched_amount" => 40,
            "total_dc_transfer_reward" => 300,
            "total_offloaded_bytes" => 750
          },
          {
            "service_provider_id" => "movistar",
            "total_service_provider_amount" => 75,
            "total_matched_amount" => 30,
            "total_dc_transfer_reward" => 150,
            "total_offloaded_bytes" => 300
          }
        ]
      })
    end

    it "raises FeatureNotAvailableError when aggregate_endpoints is disabled" do
      User.with_stubbed_plan("community") do
        api_get(totals_by_service_provider_helium_l2_mobile_reward_shares_path(
          from: Time.zone.yesterday,
          to: Time.zone.tomorrow,
        ))
      end

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
