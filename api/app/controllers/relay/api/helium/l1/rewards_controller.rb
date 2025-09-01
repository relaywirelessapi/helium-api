# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class RewardsController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          class IndexContract < ResourceController::IndexContract
            attribute :account_address, :string
            attribute :gateway_address, :string
            attribute :transaction_hash, :string
            attribute :type, :string
            attribute :block, :integer
            attribute :from, :datetime
            attribute :to, :datetime

            validates :from, comparison: { allow_blank: true, less_than: :to }
            validates :to, comparison: { allow_blank: true, greater_than: :from }
          end

          sig { void }
          def index
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L1::Reward.all

            relation = relation.where(account_address: contract.account_address) if contract.account_address.present?
            relation = relation.where(gateway_address: contract.gateway_address) if contract.gateway_address.present?
            relation = relation.where(transaction_hash: contract.transaction_hash) if contract.transaction_hash.present?
            relation = relation.where(type: contract.type) if contract.type.present?
            relation = relation.where(block: contract.block) if contract.block.present?
            relation = relation.where("time >= ?", contract.from) if contract.from.present?
            relation = relation.where("time <= ?", contract.to) if contract.to.present?

            relation = paginate(relation)

            render json: render_collection(relation, blueprint: RewardBlueprint)
          end

          private

          sig { void }
          def require_hotspot_data_feature!
            require_feature!(Relay::Billing::Features::HotspotData)
          end
        end
      end
    end
  end
end
