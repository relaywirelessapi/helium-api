# typed: false
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GraphQL persisted queries", type: :request do
  it "returns IoT reward shares for a given time period" do
    user = create(:user)
    helium_l2_iot_reward_share = create(:helium_l2_iot_reward_share)

    get(
      iot_reward_shares_graphql_query_path(
        start_period: helium_l2_iot_reward_share.start_period.beginning_of_day.iso8601,
        end_period: helium_l2_iot_reward_share.end_period.end_of_day.iso8601,
        hotspot_key: helium_l2_iot_reward_share.hotspot_key
      ),
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{user.api_key}"
      }
    )

    expect(parsed_response["data"]["iotRewardShares"]["nodes"].size).to eq(1)
  end

  it "returns mobile reward shares for a given time period" do
    user = create(:user)
    helium_l2_mobile_reward_share = create(:helium_l2_mobile_reward_share)

    get(
      mobile_reward_shares_graphql_query_path(
        start_period: helium_l2_mobile_reward_share.start_period.beginning_of_day.iso8601,
        end_period: helium_l2_mobile_reward_share.end_period.end_of_day.iso8601,
        hotspot_key: helium_l2_mobile_reward_share.hotspot_key
      ),
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{user.api_key}"
      }
    )

    expect(parsed_response["data"]["mobileRewardShares"]["nodes"].size).to eq(1)
  end

  it "returns reward manifests for a given time period" do
    user = create(:user)
    helium_l2_reward_manifest = create(:helium_l2_reward_manifest)

    get(
      reward_manifests_graphql_query_path(
        start_timestamp: helium_l2_reward_manifest.start_timestamp.beginning_of_day.iso8601,
        end_timestamp: helium_l2_reward_manifest.end_timestamp.end_of_day.iso8601
      ),
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{user.api_key}"
      }
    )

    expect(parsed_response["data"]["rewardManifests"]["nodes"].size).to eq(1)
  end
end
