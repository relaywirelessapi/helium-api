# typed: strict

module Relay
  module Helium
    module L1
      class DcBurn < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l1_dc_burns"
        self.inheritance_column = :_type

        belongs_to :actor, class_name: "Relay::Helium::L1::Account", foreign_key: :actor_address, primary_key: :address, inverse_of: :dc_burns
        belongs_to :helium_transaction, class_name: "Relay::Helium::L1::Transaction", foreign_key: :transaction_hash, primary_key: :transaction_hash, inverse_of: :dc_burns
      end
    end
  end
end
