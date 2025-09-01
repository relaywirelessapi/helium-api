# typed: strict

module Relay
  module Solana
    module Idl
      class ErrorDefinition
        extend T::Sig

        sig { returns(Integer) }
        attr_reader :code

        sig { returns(String) }
        attr_reader :name

        sig { returns(String) }
        attr_reader :msg

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(ErrorDefinition) }
          def from_data(data)
            new(
              code: data.fetch("code"),
              name: data.fetch("name"),
              msg: data.fetch("msg"),
            )
          end
        end

        sig do
          params(
            code: Integer,
            name: String,
            msg: String
          ).void
        end
        def initialize(code:, name:, msg:)
          @code = code
          @name = name
          @msg = msg
        end
      end
    end
  end
end
