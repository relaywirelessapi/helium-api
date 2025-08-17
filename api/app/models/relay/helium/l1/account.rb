# typed: strict

module Relay
  module Helium
    module L1
      class Account < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l1_accounts"

        has_many :rewards, class_name: "Relay::Helium::L1::Reward", foreign_key: :account_address, primary_key: :address, dependent: :destroy, inverse_of: :account
        has_many :dc_burns, class_name: "Relay::Helium::L1::DcBurn", foreign_key: :actor_address, primary_key: :address, dependent: :destroy, inverse_of: :actor
        has_many :owned_gateways, class_name: "Relay::Helium::L1::Gateway", foreign_key: :owner_address, primary_key: :address, dependent: :destroy, inverse_of: :owner
        has_many :paid_gateways, class_name: "Relay::Helium::L1::Gateway", foreign_key: :payer_address, primary_key: :address, dependent: :destroy, inverse_of: :payer
        has_many :transaction_actors, class_name: "Relay::Helium::L1::TransactionActor", foreign_key: :actor_address, primary_key: :address, dependent: :destroy, inverse_of: :actor
      end
    end
  end
end
