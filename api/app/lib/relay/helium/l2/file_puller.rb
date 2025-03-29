# typed: strict

module Relay
  module Helium
    module L2
      class FilePuller
        extend T::Sig

        sig { returns(FileClient) }
        attr_reader :file_client

        sig { params(file_client: FileClient).void }
        def initialize(file_client: FileClient.new)
          @file_client = file_client
        end

        sig { params(definition: FileDefinition, block: T.proc.params(oracle_file: File).void).void }
        def pull_for(definition, &block)
          last_pulled_file = definition.last_pulled_file
          start_after = last_pulled_file&.s3_key

          file_client.each_object(
            bucket: T.must(definition.bucket),
            prefix: definition.s3_prefix,
            start_after: start_after
          ) do |object|
            file = File.create!(
              definition_id: definition.id,
              s3_key: object.key,
            )

            block.call(file)
          end
        end
      end
    end
  end
end
