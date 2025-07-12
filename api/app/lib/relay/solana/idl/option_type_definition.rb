# typed: strict

module Relay
  module Solana
    module Idl
      class OptionTypeDefinition < TypeDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: T.untyped).returns(OptionTypeDefinition) }
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
            program: ProgramDefinition
          ).returns([ T.untyped, Integer ])
        end
        def deserialize(data, offset:, program:)
          has_value, offset = ScalarTypeDefinition.new(type: :u8).deserialize(
            data,
            offset: offset,
            program: program
          )

          return [ nil, offset ] if has_value == 0

          type.deserialize(
            data,
            offset: offset,
            program: program
          )
        end
      end
    end
  end
end
