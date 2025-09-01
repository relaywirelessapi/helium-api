# typed: strict

module Relay
  module Helium
    module L1
      module Importers
        class AccountImporter < BaseImporter
          extend T::Sig

          sig { override.returns(String) }
          def prefix
            "blockchain-etl-export/account_inventory/"
          end

          sig { override.returns(T.class_of(ApplicationRecord)) }
          def model_klass
            Relay::Helium::L1::Account
          end

          sig { override.params(row: T::Array[String]).returns(T.nilable(T::Hash[Symbol, T.untyped])) }
          def parse_row(row)
            return if row[0] == "address"

            {
              address: row[0],
              balance: row[1].to_i,
              nonce: row[2].to_i,
              dc_balance: row[3].to_i,
              dc_nonce: row[4].to_i,
              security_balance: row[5].to_i,
              security_nonce: row[6].to_i,
              first_block: row[7].to_i,
              last_block: row[8].to_i,
              staked_balance: row[9].to_i,
              mobile_balance: row[10].to_i,
              iot_balance: row[11].to_i
            }
          end
        end
      end
    end
  end
end
