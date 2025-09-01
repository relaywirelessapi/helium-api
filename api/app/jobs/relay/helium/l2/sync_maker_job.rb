# typed: strict

module Relay
  module Helium
    module L2
      class SyncMakerJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { params(address: String, data: String).void }
        def perform(address, data)
          MakerSyncer.new.deserialize_and_sync_maker(address, Base64.decode64(data))
        end
      end
    end
  end
end
