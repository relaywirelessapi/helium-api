# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class TransactionActorBlueprint < Blueprinter::Base
          identifier :id

          field :actor_address
          field :actor_role
          field :transaction_hash
          field :block
        end
      end
    end
  end
end
