# typed: false

module Relay
  module Api
    class ResourceController < ApplicationController
      class IndexContract
        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :page, :integer, default: 1
        attribute :per_page, :integer, default: Kaminari.config.default_per_page

        validates :page, numericality: { only_integer: true, greater_than: 0 }
        validates :per_page, numericality: { in: 1..Kaminari.config.max_per_page }
      end

      protect_from_forgery with: :null_session

      before_action :require_authentication!
      before_action :verify_usage_limit

      after_action :increment_api_usage

      rate_limit(
        if: -> { current_api_user.present? },
        by: -> { current_api_user&.api_key },
        to: 120,
        within: 1.minute,
        name: "api_key_rate_limit",
        with: -> { raise Errors::RateLimitExceededError }
      )

      rate_limit(
        if: -> { current_api_user.blank? },
        by: -> { request.ip },
        to: 60,
        within: 1.minute,
        name: "ip_rate_limit",
        with: -> { raise Errors::RateLimitExceededError }
      )

      rescue_from Errors::BaseError do |exception|
        blueprint = case exception
        when Errors::InvalidContractError
          Errors::InvalidContractErrorBlueprint
        else
          Errors::BaseErrorBlueprint
        end

        render status: exception.status_code, json: blueprint.render(exception)
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
        return if current_api_user

        raise Errors::AuthenticationRequiredError
      end

      def verify_usage_limit
        return unless current_api_user&.api_usage_limit_exceeded_with?(1)

        raise Errors::UsageLimitExceededError.new(
          usage_limit: current_api_user.plan.api_usage_limit,
          usage_resets_at: current_api_user.next_api_usage_reset
        )
      end

      def build_contract(contract_klass)
        contract_klass.new(params.permit(*contract_klass.attribute_names))
      end

      def validate_contract(contract)
        return if contract.valid?

        raise Errors::InvalidContractError.new(contract)
      end

      def build_and_validate_contract(contract_klass)
        contract = build_contract(contract_klass)
        validate_contract(contract)
        contract
      end

      def increment_api_usage
        current_api_user.increment_api_usage_by(1)
      end

      def paginate(relation)
        relation.page(params[:page]).per(params[:per_page])
      end

      def render_collection(relation, blueprint:)
        blueprint.render(relation, root: :records, meta: {
          pagination: {
            count: relation.total_count,
            total_pages: relation.total_pages,
            current_page: relation.current_page,
            next_page: relation.next_page,
            prev_page: relation.prev_page
          }
        })
      end

      def require_feature!(feature_klass)
        raise Errors::FeatureNotAvailableError unless current_api_user.plan.feature?(feature_klass)
      end
    end
  end
end
