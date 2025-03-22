# typed: false
# frozen_string_literal: true

class GraphqlController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :require_authentication!

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    result = HeliumApiSchema.execute(
      query,
      variables: variables,
      context: { current_user: current_api_user || current_user },
      operation_name: operation_name
    )

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

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
