# typed: strict

module Relay
  class BatchImporter
    extend T::Sig

    sig { returns(Deduplicator) }
    attr_reader :deduplicator

    sig { params(deduplicator: Deduplicator).void }
    def initialize(deduplicator: Deduplicator.new)
      @deduplicator = T.let(deduplicator, Deduplicator)
    end

    sig { params(model_klass: T.class_of(ApplicationRecord), rows: T::Array[T::Hash[Symbol, T.untyped]]).void }
    def import(model_klass, rows)
      column_names = T.let(model_klass.column_names - [ "id" ], T::Array[String]).map(&:to_sym)

      normalized_messages = rows.map do |row|
        column_names.each_with_object({}) do |column, result|
          result[column] = row[column]
        end.merge(deduplication_key: deduplicator.calculate_deduplication_key(row))
      end

      model_klass.import(normalized_messages, on_duplicate_key_ignore: true)
    end
  end
end
