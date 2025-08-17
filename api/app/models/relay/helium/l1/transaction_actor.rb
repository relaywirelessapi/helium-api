# typed: strict

module Relay
  module Helium
    module L1
      class TransactionActor < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l1_transaction_actors"

        belongs_to(
          :helium_transaction,
          class_name: "Relay::Helium::L1::Transaction",
          foreign_key: :transaction_hash,
          primary_key: :transaction_hash,
          inverse_of: :actors,
          optional: true
        )

        belongs_to(
          :actor,
          class_name: "Relay::Helium::L1::Account",
          foreign_key: :actor_address,
          primary_key: :address,
          inverse_of: :transaction_actors,
          optional: true
        )
      end
    end
  end
end
