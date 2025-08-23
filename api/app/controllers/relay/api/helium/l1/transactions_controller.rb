# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class TransactionsController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          class IndexContract < ResourceController::IndexContract
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

            relation = Relay::Helium::L1::Transaction.all

            relation = relation.where(transaction_hash: contract.transaction_hash) if contract.transaction_hash.present?
            relation = relation.where(type: contract.type) if contract.type.present?
            relation = relation.where(block: contract.block) if contract.block.present?
            relation = relation.where("time >= ?", contract.from) if contract.from.present?
            relation = relation.where("time <= ?", contract.to) if contract.to.present?

            relation = paginate(relation)

            render json: render_collection(relation, blueprint: TransactionBlueprint)
          end

          sig { void }
          def show
            search_term = params.fetch(:id)

            if search_term.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
              transaction = Relay::Helium::L1::Transaction.find(search_term)
            else
              transaction = Relay::Helium::L1::Transaction.find_by!(transaction_hash: search_term)
            end

            render json: TransactionBlueprint.render(transaction)
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
