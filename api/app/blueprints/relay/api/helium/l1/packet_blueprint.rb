# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class PacketBlueprint < Blueprinter::Base
          identifier :id

          field :block
          field :transaction_hash
          field :time
          field :gateway_address
          field :num_packets
          field :num_dcs
        end
      end
    end
  end
end
