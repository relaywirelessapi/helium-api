# typed: false

module Faker
  class Blockchain
    class Solana < Base
      class << self
        def address
          raw_bytes = Faker::Config.random.bytes(32)
          Relay::Base58Encoder.new.base58_from_data(raw_bytes)
        end
      end
    end
  end
end
