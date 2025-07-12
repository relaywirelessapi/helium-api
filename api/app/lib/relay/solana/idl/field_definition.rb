# typed: strict

module Relay
  module Solana
    module Idl
      class FieldDefinition
        extend T::Sig

        sig { returns(String) }
        attr_reader :name

        sig { returns(TypeDefinition) }
        attr_reader :type

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(FieldDefinition) }
          def from_data(data)
            new(
              name: data.fetch("name"),
              type: TypeDefinition.from_data(data.fetch("type")),
            )
          end
        end

        sig { params(name: String, type: TypeDefinition).void }
        def initialize(name:, type:)
          @name = name
          @type = type
        end
      end
    end
  end
end
