# typed: false
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GraphQL pagination", type: :request do
  it "returns all rewards when no pagination arguments are provided" do
    user = create(:user)
    start_time = Time.parse("2024-01-01T00:00:00Z")
    end_time = Time.parse("2024-01-04T00:00:00Z")
    create(:helium_l2_iot_reward_share, start_period: start_time, end_period: end_time, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: start_time + 1.day, end_period: end_time, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: start_time + 2.days, end_period: end_time, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: start_time + 3.days, end_period: end_time, amount: 400)

    query = <<~GRAPHQL
      query {
        iotRewardShares(startPeriod: "#{start_time.iso8601}", endPeriod: "#{end_time.iso8601}") {
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
    start_time = Time.parse("2024-01-01T00:00:00Z")
    end_time = Time.parse("2024-01-04T00:00:00Z")
    create(:helium_l2_iot_reward_share, start_period: start_time, end_period: end_time, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: start_time + 1.day, end_period: end_time, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: start_time + 2.days, end_period: end_time, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: start_time + 3.days, end_period: end_time, amount: 400)

    query = <<~GRAPHQL
      query($first: Int) {
        iotRewardShares(first: $first, startPeriod: "#{start_time.iso8601}", endPeriod: "#{end_time.iso8601}") {
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
    start_time = Time.parse("2024-01-01T00:00:00Z")
    end_time = Time.parse("2024-01-04T00:00:00Z")
    create(:helium_l2_iot_reward_share, start_period: start_time, end_period: end_time, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: start_time + 1.day, end_period: end_time, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: start_time + 2.days, end_period: end_time, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: start_time + 3.days, end_period: end_time, amount: 400)

    query = <<~GRAPHQL
      query($last: Int) {
        iotRewardShares(last: $last, startPeriod: "#{start_time.iso8601}", endPeriod: "#{end_time.iso8601}") {
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
    start_time = Time.parse("2024-01-01T00:00:00Z")
    end_time = Time.parse("2024-01-04T00:00:00Z")
    create(:helium_l2_iot_reward_share, start_period: start_time, end_period: end_time, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: start_time + 1.day, end_period: end_time, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: start_time + 2.days, end_period: end_time, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: start_time + 3.days, end_period: end_time, amount: 400)

    query = <<~GRAPHQL
      query($first: Int, $after: String) {
        iotRewardShares(first: $first, after: $after, startPeriod: "#{start_time.iso8601}", endPeriod: "#{end_time.iso8601}") {
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
    start_time = Time.parse("2024-01-01T00:00:00Z")
    end_time = Time.parse("2024-01-04T00:00:00Z")
    create(:helium_l2_iot_reward_share, start_period: start_time, end_period: end_time, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: start_time + 1.day, end_period: end_time, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: start_time + 2.days, end_period: end_time, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: start_time + 3.days, end_period: end_time, amount: 400)

    query = <<~GRAPHQL
      query($last: Int, $before: String) {
        iotRewardShares(last: $last, before: $before, startPeriod: "#{start_time.iso8601}", endPeriod: "#{end_time.iso8601}") {
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

  it "maintains sort order (ascending by start_period)" do
    user = create(:user)
    start_time = Time.parse("2024-01-01T00:00:00Z")
    end_time = Time.parse("2024-01-04T00:00:00Z")
    create(:helium_l2_iot_reward_share, start_period: start_time, end_period: end_time, amount: 100)
    create(:helium_l2_iot_reward_share, start_period: start_time + 1.day, end_period: end_time, amount: 200)
    create(:helium_l2_iot_reward_share, start_period: start_time + 2.days, end_period: end_time, amount: 300)
    create(:helium_l2_iot_reward_share, start_period: start_time + 3.days, end_period: end_time, amount: 400)

    query = <<~GRAPHQL
      query {
        iotRewardShares(startPeriod: "#{start_time.iso8601}", endPeriod: "#{end_time.iso8601}") {
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
    expect(start_periods).to eq(start_periods.sort)
  end
end
