# typed: strict

module Relay
  module Helium
    module L2
      class InitializeMakersJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { void }
        def perform
          MakerSyncer.new.list_makers.each do |maker_account|
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
