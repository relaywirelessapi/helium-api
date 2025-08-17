# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class AccountsController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          sig { void }
          def index
            relation = paginate(Relay::Helium::L1::Account.all)

            relation = relation.where(address: params[:address]) if params[:address].present?

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
