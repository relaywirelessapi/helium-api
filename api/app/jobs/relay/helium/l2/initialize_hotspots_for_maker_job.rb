# typed: strict

module Relay
  module Helium
    module L2
      class InitializeHotspotsForMakerJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { params(maker: Maker).void }
        def perform(maker)
          HotspotSyncer.new.list_hotspots_for_maker(maker).each do |asset|
            SyncHotspotJob.perform_later(asset.fetch("id"))
          end
        end
      end
    end
  end
end
