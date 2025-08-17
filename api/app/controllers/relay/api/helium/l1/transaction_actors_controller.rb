# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class TransactionActorsController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          sig { void }
          def index
            relation = paginate(Relay::Helium::L1::TransactionActor.all)

            relation = relation.where(actor_address: params[:actor_address]) if params[:actor_address].present?
            relation = relation.where(transaction_hash: params[:transaction_hash]) if params[:transaction_hash].present?
            relation = relation.where(actor_role: params[:actor_role]) if params[:actor_role].present?
            relation = relation.where(block: params[:block]) if params[:block].present?

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
