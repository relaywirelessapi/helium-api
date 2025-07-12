# typed: strict

module Relay
  module Solana
    module Idl
      class EnumTypeDefinition < TypeDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(EnumTypeDefinition) }
          def from_data(data)
            new(
              variants: data.fetch("variants").map { |variant| VariantDefinition.from_data(variant) }
            )
          end
        end

        sig { returns(T::Array[VariantDefinition]) }
        attr_reader :variants

        sig { params(variants: T::Array[VariantDefinition]).void }
        def initialize(variants:)
          @variants = variants
        end
      end
    end
  end
end
