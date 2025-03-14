# typed: strict

module Relay
  module Helium
    module L2
      class PullFilesForDefinitionJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { params(definition_id: String).void }
        def perform(definition_id)
          definition = Relay::Helium::L2::FileDefinition.find!(definition_id)

          FilePuller.new.pull_for(definition) do |oracle_file|
            ProcessFileJob.perform_later(oracle_file)
          end
        end
      end
    end
  end
end
