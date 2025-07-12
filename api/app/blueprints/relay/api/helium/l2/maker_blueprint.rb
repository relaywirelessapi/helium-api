# typed: strict

module Relay
  module Api
    module Helium
      module L2
        class MakerBlueprint < Blueprinter::Base
          identifier :id

          field :address
          field :update_authority
          field :issuing_authority
          field :name
          field :bump_seed
          field :collection
          field :merkle_tree
          field :collection_bump_seed
          field :dao
        end
      end
    end
  end
end
