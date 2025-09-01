# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class DcBurnBlueprint < Blueprinter::Base
          identifier :id

          field :block
          field :transaction_hash
          field :actor_address
          field :type
          field :amount
          field :oracle_price
          field :time
        end
      end
    end
  end
end
