# typed: strict

module Relay
  module Helium
    module L2
      class FileProcessor
        extend T::Sig

        sig { returns(FileClient) }
        attr_reader :file_client

        sig { returns(FileDecoder) }
        attr_reader :file_decoder

        sig { returns(Integer) }
        attr_reader :batch_size

        sig { params(file_client: FileClient, file_decoder: FileDecoder, batch_size: Integer).void }
        def initialize(file_client: FileClient.new, file_decoder: FileDecoder.new, batch_size: 100)
          @file_client = T.let(file_client, FileClient)
          @file_decoder = T.let(file_decoder, FileDecoder)
          @batch_size = T.let(batch_size, Integer)
        end

        sig { params(oracle_file: File).void }
        def process(oracle_file)
          oracle_file.update!(started_at: Time.current)

          file_path = Rails.root.join("tmp/helium-l2-file-#{SecureRandom.uuid}.gz")

          file_client.get_object(
            bucket: T.must(oracle_file.definition).bucket,
            key: oracle_file.s3_key,
            response_target: file_path
          )

          deserializer = T.must(oracle_file.definition).deserializer

          file_decoder.messages_in(file_path).each_slice(batch_size) do |decoder_results|
            records = decoder_results.map do |decoder_result|
              deserializer.deserialize(decoder_result.message)
            end
            deserializer.import(records)

            new_position = T.must(decoder_results.last).position
            oracle_file.update!(position: new_position)
          end

          oracle_file.update!(completed_at: Time.current)
        end
      end
    end
  end
end
