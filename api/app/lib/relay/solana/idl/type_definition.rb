# typed: strict

module Relay
  module Solana
    module Idl
      class TypeDefinition
        class << self
          extend T::Sig

          sig do
            params(data: T.untyped).returns(T.any(
              ScalarTypeDefinition,
              StructTypeDefinition,
              EnumTypeDefinition,
              DefinedTypeDefinition,
              OptionTypeDefinition,
              VecTypeDefinition,
              ArrayTypeDefinition
            ))
          end
          def from_data(data)
            type_definition = if data.is_a?(String)
              ScalarTypeDefinition.from_data(data)
            elsif data.is_a?(Hash)
              if data.key?("kind")
                case data.fetch("kind")
                when "struct"
                  StructTypeDefinition.from_data(data)
                when "enum"
                  EnumTypeDefinition.from_data(data)
                end
              else
                if data.key?("defined")
                  DefinedTypeDefinition.from_data(data.fetch("defined"))
                elsif data.key?("option")
                  OptionTypeDefinition.from_data(data.fetch("option"))
                elsif data.key?("vec")
                  VecTypeDefinition.from_data(data.fetch("vec"))
                elsif data.key?("array")
                  ArrayTypeDefinition.from_data(data.fetch("array"))
                end
              end
            end

            type_definition || raise(ArgumentError, "Unknown type definition for: #{data.inspect}")
          end
        end

        extend T::Sig

        sig do
          params(
            data: String,
            offset: Integer,
            program_definition: ProgramDefinition
          ).returns([ T.untyped, Integer ])
        end
        def deserialize(data, offset:, program_definition:)
          raise NotImplementedError, "Type definitions must implement #deserialize"
        end
      end
    end
  end
end
