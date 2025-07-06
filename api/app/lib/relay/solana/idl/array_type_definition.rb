# typed: strict

module Relay
  module Solana
    module Idl
      class ArrayTypeDefinition < TypeDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: T::Array[T.untyped]).returns(ArrayTypeDefinition) }
          def from_data(data)
            new(
              type: TypeDefinition.from_data(data.fetch(0)),
              length: data.fetch(1)
            )
          end
        end

        sig { returns(TypeDefinition) }
        attr_reader :type

        sig { returns(Integer) }
        attr_reader :length

        sig { params(type: TypeDefinition, length: Integer).void }
        def initialize(type:, length:)
          @type = type
          @length = length
        end
      end
    end
  end
end
