# typed: strict
# frozen_string_literal: true

module Relay
  module Api
    module Helium
      module L2
        class HotspotsController < ResourceController
          extend T::Sig

          class IndexContract < ResourceController::IndexContract
            attribute :owner, :string
            attribute :asset_id, :string
            attribute :ecc_key, :string
            attribute :iot_info_address, :string
            attribute :mobile_info_address, :string
            attribute :networks, :string
            attribute :maker_id, :string
          end

          sig { void }
          def index
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L2::Hotspot.all

            relation = relation.where(owner: contract.owner) if contract.owner.present?
            relation = relation.where(asset_id: contract.asset_id) if contract.asset_id.present?
            relation = relation.where(ecc_key: contract.ecc_key) if contract.ecc_key.present?
            relation = relation.where(iot_info_address: contract.iot_info_address) if contract.iot_info_address.present?
            relation = relation.where(mobile_info_address: contract.mobile_info_address) if contract.mobile_info_address.present?

            if contract.networks.present?
              network_array = contract.networks.split(",").map(&:strip)
              relation = relation.where("networks && ARRAY[?]::varchar[]", network_array)
            end

            relation = relation.where(maker_id: contract.maker_id) if contract.maker_id.present?

            relation = paginate(relation)

            render json: render_collection(relation, blueprint: HotspotBlueprint)
          end
        end
      end
    end
  end
end
