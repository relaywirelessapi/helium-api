# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class TransactionActorsController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          class IndexContract < ResourceController::IndexContract
            attribute :actor_address, :string
            attribute :transaction_hash, :string
            attribute :actor_role, :string
            attribute :block, :integer
          end

          sig { void }
          def index
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L1::TransactionActor.all

            relation = relation.where(actor_address: contract.actor_address) if contract.actor_address.present?
            relation = relation.where(transaction_hash: contract.transaction_hash) if contract.transaction_hash.present?
            relation = relation.where(actor_role: contract.actor_role) if contract.actor_role.present?
            relation = relation.where(block: contract.block) if contract.block.present?

            relation = paginate(relation)

            render json: render_collection(relation, blueprint: TransactionActorBlueprint)
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
