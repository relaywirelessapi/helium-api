# typed: strict

module Relay
  module Helium
    module L1
      class ImportFileJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { params(file: Relay::Helium::L1::File).void }
        def perform(file)
          return if file.processed_at.present?

          orchestrator = Relay::Helium::L1::ImportOrchestrator.new

          ActiveRecord::Base.transaction do
            orchestrator.import_file(file.importer, file.file_name)
            file.update!(processed_at: Time.current)
          end
        end
      end
    end
  end
end
