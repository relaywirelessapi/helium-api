# typed: false
# frozen_string_literal: true

class GraphqlController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :require_authentication!

  # Rate limit based on API key for authenticated users
  rate_limit to: 120, within: 1.minute, by: -> { current_api_user&.api_key }, name: "api_key_rate_limit"

  # Rate limit based on IP for unauthenticated requests
  rate_limit to: 60, within: 1.minute, by: -> { request.ip }, name: "ip_rate_limit"

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
      query: fetch_persisted_query(params.fetch(:query_id)),
      variables: variables,
    )
  end

  private

  def fetch_persisted_query(query_id)
    JSON.parse(File.read(Rails.root.join("config", "data", "persisted-queries.json"))).fetch(query_id)
  end

  def execute_query(query:, variables:)
    result = Relay::Graphql::Executor.new(
      schema: Relay::ApplicationSchema,
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
