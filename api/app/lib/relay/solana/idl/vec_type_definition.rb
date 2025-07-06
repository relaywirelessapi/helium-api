# typed: strict

module Relay
  module Solana
    module Idl
      class VecTypeDefinition < TypeDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: T.untyped).returns(VecTypeDefinition) }
          def from_data(data)
            new(type: TypeDefinition.from_data(data))
          end
        end

        sig { returns(TypeDefinition) }
        attr_reader :type

        sig { params(type: TypeDefinition).void }
        def initialize(type:)
          @type = type
        end
      end
    end
  end
end
