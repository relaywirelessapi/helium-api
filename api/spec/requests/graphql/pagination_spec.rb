# typed: false
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GraphQL pagination", type: :request do
  it "returns all rewards when no pagination arguments are provided" do
    user = create(:user)
    create(:helium_l2_iot_reward_share, start_period: 3.days.ago, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: 2.days.ago, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: 1.day.ago, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: Time.current, amount: 400)

    query = <<~GRAPHQL
      query {
        iotRewardShares {
          edges {
            cursor
            node {
              startPeriod
              amount
            }
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
        }
      }
    GRAPHQL

    execute_graphql_query(query, api_key: user.api_key)

    expect(response).to have_http_status(:ok)
    expect(parsed_response["data"]["iotRewardShares"]["edges"].size).to eq(4)
    expect(parsed_response["data"]["iotRewardShares"]["pageInfo"]).to include(
      "hasNextPage" => false,
      "hasPreviousPage" => false
    )
  end

  it "returns first N rewards when first argument is provided" do
    user = create(:user)
    create(:helium_l2_iot_reward_share, start_period: 3.days.ago, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: 2.days.ago, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: 1.day.ago, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: Time.current, amount: 400)

    query = <<~GRAPHQL
      query($first: Int) {
        iotRewardShares(first: $first) {
          edges {
            cursor
            node {
              startPeriod
              amount
            }
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
        }
      }
    GRAPHQL

    execute_graphql_query(query, api_key: user.api_key, variables: { first: 2 })

    expect(response).to have_http_status(:ok)
    expect(parsed_response["data"]["iotRewardShares"]["edges"].size).to eq(2)
    expect(parsed_response["data"]["iotRewardShares"]["pageInfo"]).to include(
      "hasNextPage" => true,
      "hasPreviousPage" => false
    )
  end

  it "returns last N rewards when last argument is provided" do
    user = create(:user)
    create(:helium_l2_iot_reward_share, start_period: 3.days.ago, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: 2.days.ago, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: 1.day.ago, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: Time.current, amount: 400)

    query = <<~GRAPHQL
      query($last: Int) {
        iotRewardShares(last: $last) {
          edges {
            cursor
            node {
              startPeriod
              amount
            }
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
        }
      }
    GRAPHQL

    execute_graphql_query(query, api_key: user.api_key, variables: { last: 2 })

    aggregate_failures do
      expect(parsed_response["data"]["iotRewardShares"]["edges"].size).to eq(2)
      expect(parsed_response["data"]["iotRewardShares"]["pageInfo"]).to include(
        "hasNextPage" => false,
        "hasPreviousPage" => true
      )
    end
  end

  it "paginates forward using after cursor" do
    user = create(:user)
    create(:helium_l2_iot_reward_share, start_period: 3.days.ago, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: 2.days.ago, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: 1.day.ago, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: Time.current, amount: 400)

    query = <<~GRAPHQL
      query($first: Int, $after: String) {
        iotRewardShares(first: $first, after: $after) {
          edges {
            cursor
            node {
              startPeriod
              amount
            }
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
        }
      }
    GRAPHQL

    execute_graphql_query(query, api_key: user.api_key, variables: { first: 2 })
    end_cursor = parsed_response["data"]["iotRewardShares"]["pageInfo"]["endCursor"]
    execute_graphql_query(query, api_key: user.api_key, variables: { first: 2, after: end_cursor })

    expect(response).to have_http_status(:ok)
    expect(parsed_response["errors"]).to be_nil
    expect(parsed_response["data"]["iotRewardShares"]["edges"].size).to eq(2)
    expect(parsed_response["data"]["iotRewardShares"]["pageInfo"]).to include(
      "hasNextPage" => false,
      "hasPreviousPage" => true
    )
  end

  it "paginates backward using before cursor" do
    user = create(:user)
    create(:helium_l2_iot_reward_share, start_period: 3.days.ago, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: 2.days.ago, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: 1.day.ago, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: Time.current, amount: 400)

    query = <<~GRAPHQL
      query($last: Int, $before: String) {
        iotRewardShares(last: $last, before: $before) {
          edges {
            cursor
            node {
              startPeriod
              amount
            }
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
        }
      }
    GRAPHQL

    execute_graphql_query(query, api_key: user.api_key, variables: { last: 2 })
    start_cursor = parsed_response["data"]["iotRewardShares"]["pageInfo"]["startCursor"]
    execute_graphql_query(query, api_key: user.api_key, variables: { last: 2, before: start_cursor })

    expect(response).to have_http_status(:ok)
    expect(parsed_response["errors"]).to be_nil
    expect(parsed_response["data"]["iotRewardShares"]["edges"].size).to eq(2)
    expect(parsed_response["data"]["iotRewardShares"]["pageInfo"]).to include(
      "hasNextPage" => true,
      "hasPreviousPage" => false
    )
  end

  it "maintains sort order (descending by start_period)" do
    user = create(:user)
    create(:helium_l2_iot_reward_share, start_period: 3.days.ago, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: 2.days.ago, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: 1.day.ago, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: Time.current, amount: 400)

    query = <<~GRAPHQL
      query {
        iotRewardShares {
          edges {
            cursor
            node {
              startPeriod
              amount
            }
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
        }
      }
    GRAPHQL

    execute_graphql_query(query, api_key: user.api_key)

    expect(response).to have_http_status(:ok)
    edges = parsed_response["data"]["iotRewardShares"]["edges"]
    start_periods = edges.map { |edge| Time.parse(edge["node"]["startPeriod"]) }
    expect(start_periods).to eq(start_periods.sort.reverse)
  end
end
