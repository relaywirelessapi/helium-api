# typed: strict

module Relay
  module Helium
    module L2
      class FileDecoder
        extend T::Sig

        class DecoderResult
          extend T::Sig

          sig { returns(String) }
          attr_reader :message

          sig { returns(Integer) }
          attr_reader :position

          sig { params(message: String, position: Integer).void }
          def initialize(message:, position:)
            @message = message
            @position = position
          end
        end

        sig do
          params(
            file_path: T.any(Pathname, String),
            start_position: Integer,
          ).returns(T::Enumerator[DecoderResult])
        end
        def messages_in(file_path, start_position: 0)
          Enumerator.new do |yielder|
            Zlib::GzipReader.open(file_path) do |data|
              data.read(start_position)

              loop do
                chunk_size = data.read(4)
                break if chunk_size.blank?

                encoded_message = data.read(chunk_size.unpack1("N"))
                yielder.yield(DecoderResult.new(message: encoded_message, position: data.pos))
              end
            end
          end
        end
      end
    end
  end
end
