# typed: strict

module Relay
  class StaticModel
    extend T::Sig

    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Attributes
    include GlobalID::Identification

    attribute :id, :string
    validates :id, presence: true

    class << self
      extend T::Sig

      sig { returns(T::Array[T.attached_class]) }
      def all
        raise NotImplementedError, "#{self} must implement #all"
      end

      sig { params(id: String).returns(T.nilable(T.attached_class)) }
      def find(id)
        all.find { |definition| definition.id == id }
      end

      sig { params(id: String).returns(T.nilable(T.attached_class)) }
      def find_by_id(id)
        find(id)
      end

      sig { params(id: String).returns(T.attached_class) }
      def find!(id)
        find(id) || raise(ArgumentError, "#{self} not found: #{id}")
      end
    end
  end
end
