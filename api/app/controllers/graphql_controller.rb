# typed: false
# frozen_string_literal: true

class GraphqlController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :require_authentication!

  # Rate limit based on API key for authenticated users
  rate_limit to: 120, within: 1.minute, by: -> { current_api_user&.api_key }, name: "api_key_rate_limit"

  # Rate limit based on IP for unauthenticated requests
  rate_limit to: 60, within: 1.minute, by: -> { request.ip }, name: "ip_rate_limit"

  PERSISTED_QUERIES = {
    "iot-reward-shares" => <<~GRAPHQL,
      query IotRewards($startPeriod: ISO8601DateTime!, $endPeriod: ISO8601DateTime!, $hotspotKey: String, $first: Int, $after: String) {
        iotRewardShares(
          startPeriod: $startPeriod
          endPeriod: $endPeriod
          hotspotKey: $hotspotKey
          first: $first
          after: $after
        ) {
          edges {
            cursor
            node {
              amount
              beaconAmount
              witnessAmount
              dcTransferAmount
              rewardType
              unallocatedRewardType
              startPeriod
              endPeriod
              hotspotKey
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    GRAPHQL

    "mobile-reward-shares" => <<~GRAPHQL
      query MobileRewards($startPeriod: ISO8601DateTime!, $endPeriod: ISO8601DateTime!, $hotspotKey: String, $first: Int, $after: String) {
        mobileRewardShares(
          startPeriod: $startPeriod
          endPeriod: $endPeriod
          hotspotKey: $hotspotKey
          first: $first
          after: $after
        ) {
          edges {
            cursor
            node {
              amount
              baseCoveragePointsSum
              basePocReward
              baseRewardShares
              boostedCoveragePointsSum
              boostedPocReward
              boostedRewardShares
              cbsdId
              dcTransferReward
              discoveryLocationAmount
              endPeriod
              entity
              hotspotKey
              locationTrustScoreMultiplier
              matchedAmount
              oracleBoostedHexStatus
              ownerKey
              pocReward
              rewardType
              seniorityTimestamp
              serviceProviderAmount
              serviceProviderId
              spBoostedHexStatus
              speedtestMultiplier
              startPeriod
              subscriberId
              subscriberReward
              unallocatedRewardType
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    GRAPHQL
  }

  def execute
    execute_query(
      query: params[:query],
      variables: prepare_variables(params[:variables]),
    )
  end

  def execute_persisted_query
    variables = request.query_parameters.transform_keys do |key|
      key.to_s.underscore.camelize(:lower)
    end

    execute_query(
      query: PERSISTED_QUERIES.fetch(params.fetch(:query_id)),
      variables: variables,
    )
  end

  private

  def execute_query(query:, variables:)
    result = Relay::Graphql::Executor.new(
      schema: HeliumApiSchema,
      posthog: Relay::PostHog::Client.new
    ).execute(
      query: query,
      variables: variables,
      current_user: current_api_user || current_user
    )

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  def current_api_user
    @current_api_user ||= begin
      api_key = request.headers["Authorization"]&.split(" ")&.last
      return nil if api_key.blank?
      User.find_by(api_key: api_key)
    end
  end

  def require_authentication!
    unless current_api_user || current_user
      render json: { errors: [ { message: "Not authenticated" } ] }, status: :unauthorized
      nil
    end
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: 500
  end
end
