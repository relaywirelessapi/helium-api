# typed: strict
# frozen_string_literal: true

module Relay
  module Api
    module Helium
      module L2
        class MakersController < ResourceController
          extend T::Sig

          sig { void }
          def index
            relation = paginate(Relay::Helium::L2::Maker.all)

            render json: render_collection(relation, blueprint: MakerBlueprint)
          end
        end
      end
    end
  end
end
