# typed: strict

require "csv"

module Relay
  module Helium
    module L1
      class FileParser
        extend T::Sig

        sig { returns(Relay::Helium::FileClient) }
        attr_reader :file_client

        sig { params(file_client: Relay::Helium::FileClient).void }
        def initialize(file_client: Relay::Helium::FileClient.new)
          @file_client = file_client
        end

        sig { params(bucket: String, prefix: String, block: T.proc.params(key: String).void).void }
        def each_file(bucket, prefix, &block)
          file_client.each_object(
            bucket: bucket,
            prefix: prefix
          ) do |object|
            next unless object.key.end_with?(".csv.gz")
            yield object.key.delete_prefix(prefix)
          end
        end

        sig { params(bucket: String, key: String, block: T.proc.params(row: T::Array[String]).void).void }
        def parse(bucket, key, &block)
          Tempfile.create do |tempfile|
            file_client.get_object(bucket: bucket, key: key, response_target: tempfile.path)

            Zlib::GzipReader.open(tempfile.path) do |gz|
              CSV.new(gz).each(&block)
            end
          end
        end
      end
    end
  end
end
