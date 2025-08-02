# typed: strict
# frozen_string_literal: true

module Relay
  module Api
    module Helium
      module L2
        class MakersController < ResourceController
          extend T::Sig

          before_action :require_hotspot_data_feature!

          sig { void }
          def index
            relation = paginate(Relay::Helium::L2::Maker.all)

            render json: render_collection(relation, blueprint: MakerBlueprint)
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
