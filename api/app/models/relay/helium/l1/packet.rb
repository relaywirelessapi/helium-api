# typed: strict

module Relay
  module Helium
    module L1
      class Packet < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l1_packets"

        belongs_to(
          :gateway,
          class_name: "Relay::Helium::L1::Gateway",
          foreign_key: :gateway_address,
          primary_key: :address,
          inverse_of: :packets,
          optional: true
        )

        belongs_to(
          :helium_transaction,
          class_name: "Relay::Helium::L1::Transaction",
          foreign_key: :transaction_hash,
          primary_key: :transaction_hash,
          inverse_of: :packets,
          optional: true
        )
      end
    end
  end
end
