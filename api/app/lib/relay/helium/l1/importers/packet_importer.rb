# typed: strict

module Relay
  module Helium
    module L1
      module Importers
        class PacketImporter < BaseImporter
          extend T::Sig

          sig { override.returns(String) }
          def prefix
            "blockchain-etl-export/packets/"
          end

          sig { override.returns(T.class_of(ApplicationRecord)) }
          def model_klass
            Relay::Helium::L1::Packet
          end

          sig { override.params(row: T::Array[String]).returns(T.nilable(T::Hash[Symbol, T.untyped])) }
          def parse_row(row)
            return if row[0] == "block"

            {
              block: row[0].to_i,
              transaction_hash: row[1],
              time: row[2].to_i,
              gateway_address: row[3],
              num_packets: row[4].to_i,
              num_dcs: row[5].to_i
            }
          end
        end
      end
    end
  end
end
