# typed: strict

module Relay
  module Helium
    module L1
      class ImportFilesJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { void }
        def perform
          orchestrator = Relay::Helium::L1::ImportOrchestrator.new

          Relay::Helium::L1::File.where("processed_at IS NULL").find_each do |file|
            ActiveRecord::Base.transaction do
              orchestrator.import_file(file.importer, file.file_name)
              file.update!(processed_at: Time.current)
            end
          end
        end
      end
    end
  end
end
