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

        sig do
          params(
            data: String,
            offset: Integer,
            program_definition: ProgramDefinition
          ).returns([ T.untyped, Integer ])
        end
        def deserialize(data, offset:, program_definition:)
          type_definition = program_definition.find_type!(name).type
          type_definition.deserialize(data, offset: offset, program_definition: program_definition)
        end
      end
    end
  end
end
