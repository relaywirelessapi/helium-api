# typed: strict

module Relay
  module Helium
    module L1
      module Importers
        class DcBurnImporter < BaseImporter
          extend T::Sig

          sig { override.returns(String) }
          def prefix
            "blockchain-etl-export/dc_burns/"
          end

          sig { override.returns(T.class_of(ApplicationRecord)) }
          def model_klass
            Relay::Helium::L1::DcBurn
          end

          sig { override.params(row: T::Array[String]).returns(T.nilable(T::Hash[Symbol, T.untyped])) }
          def parse_row(row)
            return if row[0] == "block"

            {
              block: row[0].to_i,
              transaction_hash: row[1],
              actor_address: row[2],
              type: row[3],
              amount: row[4].to_i,
              oracle_price: row[5].to_i,
              time: row[6].to_i
            }
          end
        end
      end
    end
  end
end
