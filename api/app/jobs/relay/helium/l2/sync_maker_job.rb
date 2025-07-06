# typed: false

module Relay
  module Helium
    module L2
      class SyncMakerJob < ApplicationJob
        HEM_IDL_PATH = Rails.root.join("data", "idls", "helium-entity-manager.json")

        queue_as :default

        def perform(account_address, account_data)
          hem = Relay::Solana::ProgramClient.new(Relay::Solana::Idl::ProgramDefinition.from_file(HEM_IDL_PATH))

          maker_data = hem.deserialize_account("MakerV0", Base64.decode64(account_data))

          maker = Relay::Helium::L2::Maker.find_or_initialize_by(address: account_address)

          maker.update_authority = maker_data.fetch("update_authority")
          maker.issuing_authority = maker_data.fetch("issuing_authority")
          maker.name = maker_data.fetch("name")
          maker.bump_seed = maker_data.fetch("bump_seed")
          maker.collection = maker_data.fetch("collection")
          maker.merkle_tree = maker_data.fetch("merkle_tree")
          maker.collection_bump_seed = maker_data.fetch("collection_bump_seed")
          maker.dao = maker_data.fetch("dao")

          maker.save!
        end
      end
    end
  end
end
