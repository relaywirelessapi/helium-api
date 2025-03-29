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

        sig { params(file: File).void }
        def process(file)
          file.update!(started_at: Time.current)

          tempfile = Tempfile.new([ "helium-l2-file", ".gz" ])

          begin
            file_client.get_object(
              bucket: T.must(file.definition).bucket,
              key: file.s3_key,
              response_target: T.must(tempfile.path)
            )

            deserializer = T.must(file.definition).deserializer

            file_decoder.messages_in(T.must(tempfile.path), start_position: file.position).each_slice(batch_size) do |decoder_results|
              records = decoder_results.map do |decoder_result|
                deserializer.deserialize(decoder_result.message)
              end
              deserializer.import(records) unless Rails.env.development?

              new_position = T.must(decoder_results.last).position
              file.update!(position: new_position)
            end

            file.update!(completed_at: Time.current)
          rescue => e
            Sentry.capture_exception(e)
            raise
          ensure
            tempfile.close
            tempfile.unlink
          end
        end
      end
    end
  end
end
