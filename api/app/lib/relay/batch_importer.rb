# typed: strict

module Relay
  class BatchImporter
    extend T::Sig

    sig { params(model_klass: T.class_of(ApplicationRecord), rows: T::Array[T::Hash[Symbol, T.untyped]]).void }
    def import(model_klass, rows)
      column_names = T.let(model_klass.column_names, T::Array[String]).map(&:to_sym)

      normalized_messages = rows.map do |row|
        column_names.each_with_object({}) do |column, result|
          result[column] = row[column]
        end.merge(deduplication_key: calculate_deduplication_key(row))
      end

      model_klass.import(normalized_messages, on_duplicate_key_ignore: true)
    end

    private

    sig { params(row: T::Hash[Symbol, T.untyped]).returns(String) }
    def calculate_deduplication_key(row)
      sanitized_row = row.except(:id, :deduplication_key)
      Digest::MD5.hexdigest(sanitized_row.sort.to_h.to_json)
    end
  end
end
