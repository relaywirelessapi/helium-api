# typed: strict

module Relay
  module Helium
    module L2
      module Deserializers
        class BaseDeserializer
          extend T::Sig
          extend T::Helpers

          abstract!

          sig { abstract.params(message: String, file: File).returns(T::Hash[Symbol, T.untyped]) }
          def deserialize(message, file:); end

          sig { abstract.params(records: T::Array[T::Hash[Symbol, T.untyped]]).void }
          def import(records); end
        end
      end
    end
  end
end
