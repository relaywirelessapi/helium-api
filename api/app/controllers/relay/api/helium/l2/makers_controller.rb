# typed: strict

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

          sig { void }
          def show
            search_term = params.fetch(:id)

            if search_term.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
              maker = Relay::Helium::L2::Maker.find(search_term)
            else
              maker = Relay::Helium::L2::Maker.find_by!("address = :search_term", search_term: search_term)
            end

            render json: MakerBlueprint.render(maker)
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
