# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class MobileRewardSharesController < ResourceController
          extend T::Sig

          before_action :require_oracle_data_feature!

          MAX_DAILY_TOTALS_RANGE_DAYS = 366

          class IndexContract < ResourceController::IndexContract
            attribute :from, :datetime
            attribute :to, :datetime
            attribute :hotspot_key, :string
            attribute :reward_type, :string

            validates :from, presence: true, comparison: { allow_blank: true, less_than: :to }
            validates :to, presence: true, comparison: { allow_blank: true, greater_than: :from }
          end

          class DailyTotalsContract < IndexContract
            validate :range_within_max

            private

            sig { void }
            def range_within_max
              return if from.blank? || to.blank?
              return if (to - from) <= MAX_DAILY_TOTALS_RANGE_DAYS.days

              errors.add(:to, "must be within #{MAX_DAILY_TOTALS_RANGE_DAYS} days of :from")
            end
          end

          sig { void }
          def index
            rewards = paginate(relation)

            render json: render_collection(rewards, blueprint: MobileRewardShareBlueprint)
          end

          sig { void }
          def totals
            require_aggregate_endpoints!

            columns = <<~SQL
              sum(dc_transfer_reward) as total_dc_transfer_reward,
              sum(poc_reward) as total_poc_reward,
              sum(subscriber_reward) as total_subscriber_reward,
              sum(discovery_location_amount) as total_discovery_location_amount,
              sum(service_provider_amount) as total_service_provider_amount,
              sum(matched_amount) as total_matched_amount,
              sum(offloaded_bytes) as total_offloaded_bytes
            SQL

            totals = ActiveRecord::Base.connection.execute(relation.select(columns).to_sql).first

            render json: {
              total_dc_transfer_reward: totals.fetch("total_dc_transfer_reward").to_i,
              total_poc_reward: totals.fetch("total_poc_reward").to_i,
              total_subscriber_reward: totals.fetch("total_subscriber_reward").to_i,
              total_discovery_location_amount: totals.fetch("total_discovery_location_amount").to_i,
              total_service_provider_amount: totals.fetch("total_service_provider_amount").to_i,
              total_matched_amount: totals.fetch("total_matched_amount").to_i,
              total_offloaded_bytes: totals.fetch("total_offloaded_bytes").to_f
            }
          end

          sig { void }
          def daily_totals
            require_aggregate_endpoints!

            columns = <<~SQL
              date_trunc('day', end_period) as day,
              sum(dc_transfer_reward) as total_dc_transfer_reward,
              sum(poc_reward) as total_poc_reward,
              sum(subscriber_reward) as total_subscriber_reward,
              sum(discovery_location_amount) as total_discovery_location_amount,
              sum(service_provider_amount) as total_service_provider_amount,
              sum(matched_amount) as total_matched_amount,
              sum(offloaded_bytes) as total_offloaded_bytes
            SQL

            sql = relation(contract_class: DailyTotalsContract)
              .select(columns)
              .group("day")
              .order("day asc")
              .to_sql

            rows = ActiveRecord::Base.connection.execute(sql).to_a

            render json: {
              records: rows.map { |row|
                {
                  day: Date.parse(row.fetch("day").to_s).iso8601,
                  total_dc_transfer_reward: row.fetch("total_dc_transfer_reward").to_i,
                  total_poc_reward: row.fetch("total_poc_reward").to_i,
                  total_subscriber_reward: row.fetch("total_subscriber_reward").to_i,
                  total_discovery_location_amount: row.fetch("total_discovery_location_amount").to_i,
                  total_service_provider_amount: row.fetch("total_service_provider_amount").to_i,
                  total_matched_amount: row.fetch("total_matched_amount").to_i,
                  total_offloaded_bytes: row.fetch("total_offloaded_bytes").to_f
                }
              }
            }
          end

          sig { void }
          def totals_by_service_provider
            require_aggregate_endpoints!

            columns = <<~SQL
              service_provider_id,
              sum(service_provider_amount) as total_service_provider_amount,
              sum(matched_amount) as total_matched_amount,
              sum(dc_transfer_reward) as total_dc_transfer_reward,
              sum(offloaded_bytes) as total_offloaded_bytes
            SQL

            sql = relation
              .where.not(service_provider_id: nil)
              .select(columns)
              .group(:service_provider_id)
              .order(:service_provider_id)
              .to_sql

            rows = ActiveRecord::Base.connection.execute(sql).to_a

            render json: {
              records: rows.map { |row|
                {
                  service_provider_id: row.fetch("service_provider_id"),
                  total_service_provider_amount: row.fetch("total_service_provider_amount").to_i,
                  total_matched_amount: row.fetch("total_matched_amount").to_i,
                  total_dc_transfer_reward: row.fetch("total_dc_transfer_reward").to_i,
                  total_offloaded_bytes: row.fetch("total_offloaded_bytes").to_f
                }
              }
            }
          end

          private

          sig { params(contract_class: T.class_of(IndexContract)).returns(ActiveRecord::Relation) }
          def relation(contract_class: IndexContract)
            contract = build_and_validate_contract(contract_class)

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

          sig { void }
          def require_aggregate_endpoints!
            unless current_api_user.plan.find_feature!(Relay::Billing::Features::OracleData).aggregate_endpoints
              raise Errors::FeatureNotAvailableError
            end
          end
        end
      end
    end
  end
end
