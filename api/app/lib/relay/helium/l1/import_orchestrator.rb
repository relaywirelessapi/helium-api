# typed: strict

module Relay
  module Helium
    module L1
      class ImportOrchestrator
        extend T::Sig

        sig { returns(String) }
        attr_reader :bucket

        sig { returns(Integer) }
        attr_reader :batch_size

        sig { returns(FileParser) }
        attr_reader :file_parser

        sig do
          params(
            bucket: String,
            batch_size: Integer,
            file_parser: FileParser,
          ).void
        end
        def initialize(
          bucket: "foundation-helium-l1-archive-requester-pays",
          batch_size: 1000,
          file_parser: FileParser.new
        )
          @bucket = T.let(bucket, String)
          @batch_size = T.let(batch_size, Integer)
          @file_parser = T.let(file_parser, FileParser)
        end

        sig { params(importer: Importers::BaseImporter, block: T.proc.params(key: String).void).void }
        def each_file(importer, &block)
          file_parser.each_file(bucket, importer.prefix, &block)
        end

        sig { params(importer: Importers::BaseImporter, key: String).void }
        def import_file(importer, key)
          Relay::Importing::BatchDrainer.process(model_klass: importer.model_klass, batch_size: batch_size) do |drainer|
            file_parser.parse(bucket, "#{importer.prefix}#{key}") do |row|
              parsed_row = importer.parse_row(row)
              next unless parsed_row

              drainer << parsed_row
            end
          end
        end
      end
    end
  end
end
