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

            {
              address: row[0],
              owner_address: row[1],
              location: row[2],
              last_poc_challenge: row[3].present? ? row[3].to_i : nil,
              last_poc_onion_key_hash: row[4],
              witnesses: row[5],
              first_block: row[6].to_i,
              last_block: row[7].to_i,
              nonce: row[8].to_i,
              name: row[9],
              first_timestamp: Time.parse(T.must(row[10])),
              reward_scale: row[11].present? ? row[11].to_f : nil,
              elevation: row[12].to_i,
              gain: row[13].to_i,
              location_hex: row[14],
              mode: row[15],
              payer_address: row[16]
            }
          end
        end
      end
    end
  end
end
