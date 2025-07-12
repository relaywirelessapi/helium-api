# typed: strict

module Relay
  module Helium
    module L2
      class SyncHotspotJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { params(asset_id: String).void }
        def perform(asset_id)
          hotspot_syncer = Relay::Helium::L2::HotspotSyncer.new
          hotspot_syncer.sync_hotspot(asset_id)
        end
      end
    end
  end
end
