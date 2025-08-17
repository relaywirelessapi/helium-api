# typed: strict

module Relay
  module Importing
    class BatchImporter
      extend T::Sig

      sig { returns(RecordDeduplicator) }
      attr_reader :record_deduplicator

      sig { params(record_deduplicator: RecordDeduplicator).void }
      def initialize(record_deduplicator: RecordDeduplicator.new)
        @record_deduplicator = record_deduplicator
      end

      sig { params(model_klass: T.class_of(ApplicationRecord), rows: T::Array[T::Hash[Symbol, T.untyped]]).void }
      def import(model_klass, rows)
        column_names = T.let(model_klass.column_names - [ "id" ], T::Array[String]).map(&:to_sym)

        normalized_messages = rows.map do |row|
          normalized_row = column_names.each_with_object({}) do |column, result|
            result[column] = row[column]
          end

          if model_klass.column_names.include?("deduplication_key")
            normalized_row[:deduplication_key] = record_deduplicator.calculate_deduplication_key(normalized_row)
          end

          normalized_row
        end

        model_klass.import(normalized_messages, on_duplicate_key_ignore: true)
      end
    end
  end
end
