# typed: strict

module Relay
  module Helium
    module L1
      class Reward < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l1_rewards"
        self.inheritance_column = :_type

        belongs_to :account, class_name: "Relay::Helium::L1::Account", foreign_key: :account_address, primary_key: :address, inverse_of: :rewards
        belongs_to :gateway, class_name: "Relay::Helium::L1::Gateway", foreign_key: :gateway_address, primary_key: :address, inverse_of: :rewards
        belongs_to :helium_transaction, class_name: "Relay::Helium::L1::Transaction", foreign_key: :transaction_hash, primary_key: :transaction_hash, inverse_of: :rewards
      end
    end
  end
end
