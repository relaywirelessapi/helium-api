# typed: strict

module Relay
  module Helium
    module L2
      class ScheduleFileDefinitionPullsJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { void }
        def perform
          Relay::Helium::L2::FileDefinition.all.each do |definition|
            PullFilesForDefinitionJob.perform_later(definition.id)
          end
        end
      end
    end
  end
end
