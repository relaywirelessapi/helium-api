# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class RewardBlueprint < Blueprinter::Base
          identifier :id

          field :block
          field :transaction_hash
          field :time
          field :account_address
          field :gateway_address
          field :amount
          field :type
        end
      end
    end
  end
end
