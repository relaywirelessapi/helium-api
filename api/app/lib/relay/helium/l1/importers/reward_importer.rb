# typed: strict

module Relay
  module Helium
    module L1
      module Importers
        class RewardImporter < BaseImporter
          extend T::Sig

          sig { override.returns(String) }
          def prefix
            "blockchain-etl-export/rewards/"
          end

          sig { override.returns(T.class_of(ApplicationRecord)) }
          def model_klass
            Relay::Helium::L1::Reward
          end

          sig { override.params(row: T::Array[String]).returns(T.nilable(T::Hash[Symbol, T.untyped])) }
          def parse_row(row)
            return if row[0] == "block"

            {
              block: row[0].to_i,
              transaction_hash: row[1],
              time: row[2].to_i,
              account_address: row[3],
              gateway_address: row[4],
              amount: row[5].to_i,
              type: row[6]
            }
          end
        end
      end
    end
  end
end
