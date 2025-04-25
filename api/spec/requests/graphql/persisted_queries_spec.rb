# typed: false
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GraphQL persisted queries", type: :request do
  it "returns IoT reward shares for a given time period" do
    user = create(:user)
    start_time = Time.parse("2024-01-01T00:00:00Z")
    end_time = Time.parse("2024-01-04T00:00:00Z")
    hotspot_key = "11aBcDeFgHiJkLmNoPqRsTuVwXyZ123456"

    create(:helium_l2_iot_reward_share,
      start_period: start_time,
      end_period: end_time,
      amount: 100,
      beacon_amount: 50,
      witness_amount: 30,
      dc_transfer_amount: 20,
      reward_type: "iot",
      unallocated_reward_type: "none",
      hotspot_key: hotspot_key
    )

    get(
      iot_reward_shares_graphql_query_path(
        start_period: start_time.iso8601,
        end_period: end_time.iso8601,
        hotspot_key: hotspot_key
      ),
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{user.api_key}"
      }
    )

    expect(parsed_response["data"]["iotRewardShares"]["edges"].size).to eq(1)
    expect(parsed_response["data"]["iotRewardShares"]["edges"][0]["node"]).to include(
      "amount" => "100",
      "beaconAmount" => "50",
      "witnessAmount" => "30",
      "dcTransferAmount" => "20",
      "rewardType" => "iot",
      "unallocatedRewardType" => "none",
      "startPeriod" => start_time.iso8601,
      "endPeriod" => end_time.iso8601,
      "hotspotKey" => hotspot_key
    )
  end

  it "returns mobile reward shares for a given time period" do
    user = create(:user)
    start_time = Time.parse("2024-01-01T00:00:00Z")
    end_time = Time.parse("2024-01-04T00:00:00Z")
    hotspot_key = "11aBcDeFgHiJkLmNoPqRsTuVwXyZ123456"

    create(:helium_l2_mobile_reward_share,
      start_period: start_time,
      end_period: end_time,
      amount: 200,
      base_coverage_points_sum: 150.5,
      base_poc_reward: 100,
      base_reward_shares: 1.5,
      boosted_coverage_points_sum: 200.5,
      boosted_poc_reward: 150,
      boosted_reward_shares: 2.0,
      cbsd_id: "CBSD123",
      dc_transfer_reward: 50,
      discovery_location_amount: 30,
      entity: "entity123",
      hotspot_key: hotspot_key,
      location_trust_score_multiplier: 1.2,
      matched_amount: 180,
      oracle_boosted_hex_status: 1,
      owner_key: "owner123",
      poc_reward: 120,
      reward_type: "mobile",
      seniority_timestamp: 1234567890,
      service_provider_amount: 40,
      service_provider_id: "SP123",
      sp_boosted_hex_status: 1,
      speedtest_multiplier: 1.1,
      subscriber_id: "SUB123",
      subscriber_reward: 60,
      unallocated_reward_type: "none"
    )

    get(
      mobile_reward_shares_graphql_query_path(
        start_period: start_time.iso8601,
        end_period: end_time.iso8601,
        hotspot_key: hotspot_key
      ),
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{user.api_key}"
      }
    )

    expect(parsed_response["data"]["mobileRewardShares"]["edges"].size).to eq(1)
    expect(parsed_response["data"]["mobileRewardShares"]["edges"][0]["node"]).to include(
      "amount" => "200",
      "baseCoveragePointsSum" => 150.5,
      "basePocReward" => "100",
      "baseRewardShares" => 1.5,
      "boostedCoveragePointsSum" => 200.5,
      "boostedPocReward" => "150",
      "boostedRewardShares" => 2.0,
      "cbsdId" => "CBSD123",
      "dcTransferReward" => "50",
      "discoveryLocationAmount" => "30",
      "endPeriod" => end_time.iso8601,
      "entity" => "entity123",
      "hotspotKey" => hotspot_key,
      "locationTrustScoreMultiplier" => 1.2,
      "matchedAmount" => "180",
      "oracleBoostedHexStatus" => 1,
      "ownerKey" => "owner123",
      "pocReward" => "120",
      "rewardType" => "mobile",
      "seniorityTimestamp" => "1234567890",
      "serviceProviderAmount" => "40",
      "serviceProviderId" => "SP123",
      "spBoostedHexStatus" => 1,
      "speedtestMultiplier" => 1.1,
      "startPeriod" => start_time.iso8601,
      "subscriberId" => "SUB123",
      "subscriberReward" => "60",
      "unallocatedRewardType" => "none"
    )
  end
end
