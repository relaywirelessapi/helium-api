# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class HotspotsController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          class IndexContract < ResourceController::IndexContract
            attribute :owner, :string
            attribute :asset_id, :string
            attribute :ecc_key, :string
            attribute :networks, :string
            attribute :maker_id, :string
            attribute :iot_location, :integer
            attribute :mobile_location, :integer
          end

          sig { void }
          def index
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L2::Hotspot.all

            relation = relation.where(owner: contract.owner) if contract.owner.present?
            relation = relation.where(asset_id: contract.asset_id) if contract.asset_id.present?
            relation = relation.where(ecc_key: contract.ecc_key) if contract.ecc_key.present?
            relation = relation.where(maker_id: contract.maker_id) if contract.maker_id.present?
            relation = relation.by_networks(contract.networks.split(",")) if contract.networks.present?
            relation = relation.by_iot_location(contract.iot_location) if contract.iot_location.present?
            relation = relation.by_mobile_location(contract.mobile_location) if contract.mobile_location.present?

            relation = paginate(relation)

            render json: render_collection(relation, blueprint: HotspotBlueprint)
          end

          sig { void }
          def show
            search_term = params.fetch(:id)

            if search_term.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
              hotspot = Relay::Helium::L2::Hotspot.find(search_term)
            else
              hotspot = Relay::Helium::L2::Hotspot.find_by!("asset_id = :search_term OR ecc_key = :search_term", search_term: search_term)
            end

            render json: HotspotBlueprint.render(hotspot)
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
