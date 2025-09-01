# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class IotRewardSharesController < ResourceController
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

            render json: render_collection(rewards, blueprint: IotRewardShareBlueprint)
          end

          sig { void }
          def totals
            unless current_api_user.plan.find_feature!(Relay::Billing::Features::OracleData).aggregate_endpoints
              raise Errors::FeatureNotAvailableError
            end

            columns = <<~SQL
              sum(beacon_amount) as total_beacon_amount,
              sum(witness_amount) as total_witness_amount,
              sum(dc_transfer_amount) as total_dc_transfer_amount,
              sum(amount) as total_amount
            SQL

            totals = ActiveRecord::Base.connection.execute(relation.select(columns).to_sql).first

            render json: {
              total_beacon_amount: totals.fetch("total_beacon_amount").to_i,
              total_witness_amount: totals.fetch("total_witness_amount").to_i,
              total_dc_transfer_amount: totals.fetch("total_dc_transfer_amount").to_i,
              total_amount: totals.fetch("total_amount").to_i
            }
          end

          private

          sig { returns(ActiveRecord::Relation) }
          def relation
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L2::IotRewardShare

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
