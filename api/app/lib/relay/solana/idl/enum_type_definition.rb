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

        sig do
          params(
            data: String,
            offset: Integer,
            program: ProgramDefinition
          ).returns([ T.untyped, Integer ])
        end
        def deserialize(data, offset:, program:)
          discriminant, offset = ScalarTypeDefinition.new(type: :u8).deserialize(
            data,
            offset: offset,
            program: program
          )

          if discriminant < 0 || discriminant >= variants.length
            raise(
              DeserializationError,
              "Invalid enum discriminant: expected 0..#{variants.length - 1}, got #{discriminant}"
            )
          end

          variant = variants.fetch(discriminant)

          variant_data = {}

          variant.fields.each do |field|
            field_value, offset = field.type.deserialize(
              data,
              offset: offset,
              program: program
            )

            variant_data[field.name.to_sym] = field_value
          end

          [ { variant: variant.name, data: variant_data }, offset ]
        end
      end
    end
  end
end
