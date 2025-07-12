# typed: strict

module Relay
  module Solana
    module Idl
      class ProgramReferenceDefinition
        extend T::Sig

        sig { returns(String) }
        attr_reader :kind

        sig { returns(T.untyped) }
        attr_reader :value

        sig { returns(T.nilable(String)) }
        attr_reader :path

        class << self
          extend T::Sig

          sig { params(data: T::Hash[String, T.untyped]).returns(ProgramReferenceDefinition) }
          def from_data(data)
            new(
              kind: data.fetch("kind"),
              value: data["value"],
              path: data["path"],
            )
          end
        end

        sig do
          params(
            kind: String,
            value: T.untyped,
            path: T.nilable(String)
          ).void
        end
        def initialize(kind:, value: nil, path: nil)
          @kind = kind
          @value = value
          @path = path
        end

        sig { returns(T::Hash[String, T.untyped]) }
        def as_json
          {
            kind: kind,
            value: value,
            path: path
          }
        end
      end
    end
  end
end
