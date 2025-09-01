# typed: strict

module Relay
  module Helium
    module L1
      class Transaction < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l1_transactions"
        self.inheritance_column = :_type

        has_many(
          :actors,
          class_name: "Relay::Helium::L1::TransactionActor",
          foreign_key: :transaction_hash,
          primary_key: :transaction_hash,
          dependent: :destroy,
          inverse_of: :helium_transaction
        )

        has_many(
          :packets,
          class_name: "Relay::Helium::L1::Packet",
          foreign_key: :transaction_hash,
          primary_key: :transaction_hash,
          dependent: :destroy,
          inverse_of: :helium_transaction
        )

        has_many(
          :rewards,
          class_name: "Relay::Helium::L1::Reward",
          foreign_key: :transaction_hash,
          primary_key: :transaction_hash,
          dependent: :destroy,
          inverse_of: :helium_transaction
        )

        has_many(
          :dc_burns,
          class_name: "Relay::Helium::L1::DcBurn",
          foreign_key: :transaction_hash,
          primary_key: :transaction_hash,
          dependent: :destroy,
          inverse_of: :helium_transaction
        )
      end
    end
  end
end
