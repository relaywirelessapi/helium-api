# typed: strict

module Relay
  module Helium
    module L2
      class ProcessFileJob < ApplicationJob
        extend T::Sig

        sig { params(oracle_file: File).void }
        def perform(oracle_file)
          processor = FileProcessor.new
          processor.process(oracle_file)
        end
      end
    end
  end
end
