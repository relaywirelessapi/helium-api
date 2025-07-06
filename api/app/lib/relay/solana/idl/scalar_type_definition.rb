# typed: strict

module Relay
  module Solana
    module Idl
      class ScalarTypeDefinition < TypeDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: String).returns(ScalarTypeDefinition) }
          def from_data(data)
            new(type: data.to_sym.downcase)
          end
        end

        sig { returns(Symbol) }
        attr_reader :type

        sig { params(type: Symbol).void }
        def initialize(type:)
          @type = type
        end
      end
    end
  end
end
