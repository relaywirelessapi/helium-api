# typed: strict

module Relay
  module Helium
    module L2
      class InitializeHotspotsJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { void }
        def perform
          Relay::Helium::L2::Maker.find_each do |maker|
            InitializeHotspotsForMakerJob.perform_later(maker)
          end
        end
      end
    end
  end
end
