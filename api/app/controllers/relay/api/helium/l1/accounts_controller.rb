# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class AccountsController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          class IndexContract < ResourceController::IndexContract
            attribute :address, :string
          end

          sig { void }
          def index
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L1::Account.all
            relation = relation.where(address: contract.address) if contract.address.present?
            relation = paginate(relation)

            render json: render_collection(relation, blueprint: AccountBlueprint)
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
