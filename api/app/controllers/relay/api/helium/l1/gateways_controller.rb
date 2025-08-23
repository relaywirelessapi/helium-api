# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class GatewaysController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          class IndexContract < ResourceController::IndexContract
            attribute :address, :string
            attribute :owner_address, :string
            attribute :payer_address, :string
            attribute :mode, :string
            attribute :name, :string
            attribute :location_hex, :string
          end

          sig { void }
          def index
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L1::Gateway.all

            relation = relation.where(address: contract.address) if contract.address.present?
            relation = relation.where(owner_address: contract.owner_address) if contract.owner_address.present?
            relation = relation.where(payer_address: contract.payer_address) if contract.payer_address.present?
            relation = relation.where(mode: contract.mode) if contract.mode.present?
            relation = relation.where(name: contract.name) if contract.name.present?
            relation = relation.where(location_hex: contract.location_hex) if contract.location_hex.present?

            relation = paginate(relation)

            render json: render_collection(relation, blueprint: GatewayBlueprint)
          end

          sig { void }
          def show
            search_term = params.fetch(:id)

            if search_term.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
              gateway = Relay::Helium::L1::Gateway.find(search_term)
            else
              gateway = Relay::Helium::L1::Gateway.find_by!(address: search_term)
            end

            render json: GatewayBlueprint.render(gateway)
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
