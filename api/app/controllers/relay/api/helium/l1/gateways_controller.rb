# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class GatewaysController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          sig { void }
          def index
            relation = paginate(Relay::Helium::L1::Gateway.all)

            relation = relation.where(address: params[:address]) if params[:address].present?
            relation = relation.where(owner_address: params[:owner_address]) if params[:owner_address].present?
            relation = relation.where(payer_address: params[:payer_address]) if params[:payer_address].present?
            relation = relation.where(mode: params[:mode]) if params[:mode].present?
            relation = relation.where(name: params[:name]) if params[:name].present?
            relation = relation.where(location_hex: params[:location_hex]) if params[:location_hex].present?

            render json: render_collection(relation, blueprint: GatewayBlueprint)
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
