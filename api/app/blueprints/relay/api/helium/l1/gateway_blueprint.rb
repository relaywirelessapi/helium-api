# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class GatewayBlueprint < Blueprinter::Base
          identifier :id

          field :address
          field :owner_address
          field :payer_address
          field :location
          field :location_hex
          field :last_poc_challenge
          field :last_poc_onion_key_hash
          field :witnesses
          field :first_block
          field :last_block
          field :nonce
          field :name
          field :first_timestamp
          field :reward_scale
          field :elevation
          field :gain
          field :mode
        end
      end
    end
  end
end
