# typed: strict

module Relay
  module Api
    module Helium
      module L1
        class AccountBlueprint < Blueprinter::Base
          identifier :id

          field :address
          field :balance
          field :nonce
          field :dc_balance
          field :dc_nonce
          field :security_balance
          field :security_nonce
          field :first_block
          field :last_block
          field :staked_balance
          field :mobile_balance
          field :iot_balance
        end
      end
    end
  end
end
