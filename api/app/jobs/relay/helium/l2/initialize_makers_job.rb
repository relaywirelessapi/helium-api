# typed: false

module Relay
  module Helium
    module L2
      class InitializeMakersJob < ApplicationJob
        HEM_IDL_PATH = Rails.root.join("data", "idls", "helium-entity-manager.json")

        queue_as :default

        def perform
          hem = Relay::Solana::ProgramClient.new(Relay::Solana::Idl::ProgramDefinition.from_file(HEM_IDL_PATH))
          maker_accounts = hem.get_accounts("MakerV0")

          maker_accounts.each do |maker_account|
            SyncMakerJob.perform_later(
              maker_account.fetch("pubkey"),
              maker_account.fetch("account").fetch("data")[0]
            )
          end
        end
      end
    end
  end
end
