# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class MobileRewardSharesController < ResourceController
          extend T::Sig

          before_action :require_oracle_data_feature!

          class IndexContract < ResourceController::IndexContract
            attribute :from, :datetime
            attribute :to, :datetime
            attribute :hotspot_key, :string
            attribute :reward_type, :string

            validates :from, presence: true, comparison: { allow_blank: true, less_than: :to }
            validates :to, presence: true, comparison: { allow_blank: true, greater_than: :from }
          end

          sig { void }
          def index
            rewards = paginate(relation)

            render json: render_collection(rewards, blueprint: MobileRewardShareBlueprint)
          end

          sig { void }
          def totals
            unless current_api_user.plan.find_feature!(Relay::Billing::Features::OracleData).aggregate_endpoints
              raise Errors::FeatureNotAvailableError
            end

            columns = <<~SQL
              sum(dc_transfer_reward) as total_dc_transfer_reward,
              sum(poc_reward) as total_poc_reward,
              sum(subscriber_reward) as total_subscriber_reward,
              sum(discovery_location_amount) as total_discovery_location_amount,
              sum(service_provider_amount) as total_service_provider_amount,
              sum(matched_amount) as total_matched_amount
            SQL

            totals = ActiveRecord::Base.connection.execute(relation.select(columns).to_sql).first

            render json: {
              total_dc_transfer_reward: totals.fetch("total_dc_transfer_reward").to_i,
              total_poc_reward: totals.fetch("total_poc_reward").to_i,
              total_subscriber_reward: totals.fetch("total_subscriber_reward").to_i,
              total_discovery_location_amount: totals.fetch("total_discovery_location_amount").to_i,
              total_service_provider_amount: totals.fetch("total_service_provider_amount").to_i,
              total_matched_amount: totals.fetch("total_matched_amount").to_i
            }
          end

          private

          sig { returns(ActiveRecord::Relation) }
          def relation
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L2::MobileRewardShare

            relation = relation.where(end_period: [ contract.from, current_api_user.lookback_window_start_date ].max..contract.to)
            relation = relation.where(hotspot_key: contract.hotspot_key) if contract.hotspot_key.present?
            relation = relation.where(reward_type: contract.reward_type) if contract.reward_type.present?

            relation
          end

          sig { void }
          def require_oracle_data_feature!
            require_feature!(Relay::Billing::Features::OracleData)
          end
        end
      end
    end
  end
end
