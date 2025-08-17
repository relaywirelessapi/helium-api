# typed: strict

module Relay
  module Helium
    module L1
      class InitializeFilesJob < ApplicationJob
        extend T::Sig

        queue_as :default

        sig { void }
        def perform
          orchestrator = Relay::Helium::L1::ImportOrchestrator.new

          Relay::Helium::L1::File::IMPORTER_KLASSES.each_pair do |file_type, importer_klass|
            orchestrator.each_file(importer_klass.new) do |file_key|
              Relay::Helium::L1::File.create!(
                file_type: file_type,
                file_name: file_key
              )
            end
          end
        end
      end
    end
  end
end
