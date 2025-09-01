# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class TransactionBlueprint < Blueprinter::Base
          identifier :id

          field :block
          field :transaction_hash
          field :type
          field :fields
          field :time
        end
      end
    end
  end
end
