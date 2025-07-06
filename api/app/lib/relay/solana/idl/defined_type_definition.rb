# typed: strict

module Relay
  module Solana
    module Idl
      class DefinedTypeDefinition < TypeDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(DefinedTypeDefinition) }
          def from_data(data)
            new(name: data.fetch("name"))
          end
        end

        sig { returns(String) }
        attr_reader :name

        sig { params(name: String).void }
        def initialize(name:)
          @name = name
        end
      end
    end
  end
end
