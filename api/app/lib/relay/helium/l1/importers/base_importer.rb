# typed: strict

module Relay
  module Helium
    module L1
      module Importers
        class BaseImporter
          extend T::Sig
          extend T::Helpers

          abstract!

          sig { abstract.returns(String) }
          def prefix
          end

          sig { abstract.returns(T.class_of(ApplicationRecord)) }
          def model_klass
          end

          sig { abstract.params(row: T::Array[String]).returns(T.nilable(T::Hash[Symbol, T.untyped])) }
          def parse_row(row)
          end
        end
      end
    end
  end
end
