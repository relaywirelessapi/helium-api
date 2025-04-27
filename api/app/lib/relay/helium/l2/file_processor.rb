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
        def initialize(file_client: FileClient.new, file_decoder: FileDecoder.new, batch_size: 1000)
          @file_client = T.let(file_client, FileClient)
          @file_decoder = T.let(file_decoder, FileDecoder)
          @batch_size = T.let(batch_size, Integer)
        end

        sig { params(file: File, skip_import: T::Boolean).void }
        def process(file, skip_import: Rails.env.development?)
          file.update!(started_at: Time.current) unless file.started_at.present?

          Tempfile.create([ "helium-l2-file", ".gz" ]) do |tempfile|
            definition = T.must(file.definition)
            deserializer = T.must(definition.deserializer)

            file_client.get_object(
              bucket: T.must(definition.bucket),
              key: file.s3_key,
              response_target: tempfile.path
            )

            file_decoder.messages_in(tempfile.path, start_position: file.position).each_slice(batch_size) do |decoder_results|
              records = decoder_results.map do |decoder_result|
                deserializer.deserialize(decoder_result.message, file: file)
              end

              begin
                deserializer.import(records)
              rescue StandardError
                puts "Error while importing the following records: #{records.inspect}"
                raise
              end unless skip_import

              new_position = T.must(decoder_results.last).position
              file.update!(position: new_position)
            end

            file.update!(completed_at: Time.current)
          end
        rescue => e
          Sentry.capture_exception(e, extra: {
            file_id: file.id,
            file_category: file.category,
            file_name: file.name
          })

          raise
        end
      end
    end
  end
end
