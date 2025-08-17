# typed: strict

module Relay
  module Importing
    class RecordDeduplicator
      extend T::Sig

      sig { params(row: T::Hash[Symbol, T.untyped]).returns(String) }
      def calculate_deduplication_key(row)
        sanitized_row = row.except(:id, :deduplication_key)
        encoded_row = sanitize_binary_values(sanitized_row)
        Digest::MD5.hexdigest(encoded_row.sort.to_h.to_json)
      end

      private

      sig { params(row: T::Hash[Symbol, T.untyped]).returns(T::Hash[Symbol, T.untyped]) }
      def sanitize_binary_values(row)
        row.transform_values do |value|
          if value.is_a?(String) && value.encoding == Encoding::BINARY
            Base64.strict_encode64(value)
          else
            value
          end
        end
      end
    end
  end
end
