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

        sig do
          params(
            data: String,
            offset: Integer,
            program_definition: ProgramDefinition
          ).returns([ T.untyped, Integer ])
        end
        def deserialize(data, offset:, program_definition:)
          length, offset = ScalarTypeDefinition.new(type: :u32).deserialize(
            data,
            offset: offset,
            program_definition: program_definition
          )

          result = []

          length.times do
            value, offset = type.deserialize(
              data,
              offset: offset,
              program_definition: program_definition
            )
            result << value
          end

          [ result, offset ]
        end
      end
    end
  end
end
