# typed: strict

module Relay
  module Helium
    module L1
      class Gateway < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l1_gateways"

        belongs_to(
          :owner,
          class_name: "Relay::Helium::L1::Account",
          foreign_key: :owner_address,
          primary_key: :address,
          inverse_of: :owned_gateways,
          optional: true,
        )

        belongs_to(
          :payer,
          class_name: "Relay::Helium::L1::Account",
          foreign_key: :payer_address,
          primary_key: :address,
          inverse_of: :paid_gateways,
          optional: true,
        )

        has_many(
          :rewards,
          class_name: "Relay::Helium::L1::Reward",
          foreign_key: :gateway_address,
          primary_key: :address,
          dependent: :destroy,
          inverse_of: :gateway,
        )

        has_many(
          :packets,
          class_name: "Relay::Helium::L1::Packet",
          foreign_key: :gateway_address,
          primary_key: :address,
          dependent: :destroy,
          inverse_of: :gateway,
        )
      end
    end
  end
end
