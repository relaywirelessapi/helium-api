# typed: strict

module Relay
  module Helium
    module L1
      module Importers
        class GatewayImporter < BaseImporter
          extend T::Sig

          sig { override.returns(String) }
          def prefix
            "blockchain-etl-export/gateway_inventory/"
          end

          sig { override.returns(T.class_of(ApplicationRecord)) }
          def model_klass
            Relay::Helium::L1::Gateway
          end

          sig { override.params(row: T::Array[String]).returns(T.nilable(T::Hash[Symbol, T.untyped])) }
          def parse_row(row)
            return if row[0] == "address"

            raise NotImplementedError
          end
        end
      end
    end
  end
end
