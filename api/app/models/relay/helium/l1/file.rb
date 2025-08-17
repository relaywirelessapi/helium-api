# typed: strict

module Relay
  module Helium
    module L1
      class File < ApplicationRecord
        extend T::Sig

        IMPORTER_KLASSES = T.let({
          "accounts" => Relay::Helium::L1::Importers::AccountImporter,
          "gateways" => Relay::Helium::L1::Importers::GatewayImporter,
          "transactions" => Relay::Helium::L1::Importers::TransactionImporter,
          "transaction_actors" => Relay::Helium::L1::Importers::TransactionActorImporter,
          "packets" => Relay::Helium::L1::Importers::PacketImporter,
          "rewards" => Relay::Helium::L1::Importers::RewardImporter,
          "dc_burns" => Relay::Helium::L1::Importers::DcBurnImporter
        }, T::Hash[String, T.class_of(Relay::Helium::L1::Importers::BaseImporter)])

        self.table_name = "helium_l1_files"

        sig { returns(Relay::Helium::L1::Importers::BaseImporter) }
        def importer
          IMPORTER_KLASSES.fetch(file_type).new
        end
      end
    end
  end
end
