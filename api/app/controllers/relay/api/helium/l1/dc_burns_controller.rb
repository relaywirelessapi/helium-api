# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class DcBurnsController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          sig { void }
          def index
            relation = paginate(Relay::Helium::L1::DcBurn.all)

            relation = relation.where(actor_address: params[:actor_address]) if params[:actor_address].present?
            relation = relation.where(transaction_hash: params[:transaction_hash]) if params[:transaction_hash].present?
            relation = relation.where(type: params[:type]) if params[:type].present?
            relation = relation.where(block: params[:block]) if params[:block].present?
            relation = relation.where("time >= ?", params[:from]) if params[:from].present?
            relation = relation.where("time <= ?", params[:to]) if params[:to].present?

            render json: render_collection(relation, blueprint: DcBurnBlueprint)
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
