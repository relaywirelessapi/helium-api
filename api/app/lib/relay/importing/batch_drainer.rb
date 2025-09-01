# typed: strict

module Relay
  module Importing
    class BatchDrainer
      extend T::Sig

      sig { returns(T.class_of(ApplicationRecord)) }
      attr_reader :model_klass

      sig { returns(Integer) }
      attr_reader :batch_size

      sig { returns(Relay::Importing::BatchImporter) }
      attr_reader :batch_importer

      class << self
        extend T::Sig

        sig do
          params(
            model_klass: T.class_of(ApplicationRecord),
            batch_size: Integer,
            batch_importer: BatchImporter,
            block: T.proc.params(drainer: BatchDrainer).void
          ).void
        end
        def process(model_klass:, batch_size:, batch_importer: Relay::Importing::BatchImporter.new, &block)
          new(model_klass:, batch_size:, batch_importer:).tap do |drainer|
            block.call(drainer)
            drainer.flush
          end
        end
      end

      sig { params(model_klass: T.class_of(ApplicationRecord), batch_size: Integer, batch_importer: BatchImporter).void }
      def initialize(model_klass:, batch_size:, batch_importer: Relay::Importing::BatchImporter.new)
        @model_klass = model_klass
        @batch_size = batch_size
        @batch_importer = batch_importer
      end

      sig { params(row: T::Hash[Symbol, T.untyped]).void }
      def <<(row)
        current_batch << row
        flush if current_batch.size >= batch_size
      end

      sig { void }
      def flush
        batch_importer.import(model_klass, current_batch.dup)
        current_batch.clear
        GC.start
      end

      private

      sig { returns(T::Array[T::Hash[Symbol, T.untyped]]) }
      def current_batch
        @current_batch ||= T.let([], T.nilable(T::Array[T::Hash[Symbol, T.untyped]]))
      end
    end
  end
end
