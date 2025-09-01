# typed: false

FactoryBot.define do
  factory :helium_l1_account, class: "Relay::Helium::L1::Account" do
    address { Faker::Blockchain::Solana.address }
    balance { Faker::Number.between(from: 0, to: 1_000_000_000_000) }
    nonce { Faker::Number.between(from: 0, to: 100) }
    dc_balance { Faker::Number.between(from: 0, to: 1_000_000_000) }
    dc_nonce { Faker::Number.between(from: 0, to: 50) }
    security_balance { Faker::Number.between(from: 0, to: 1_000_000_000) }
    security_nonce { Faker::Number.between(from: 0, to: 50) }
    first_block { Faker::Number.between(from: 100_000, to: 2_000_000) }
    last_block { Faker::Number.between(from: 1_500_000, to: 2_000_000) }
    staked_balance { Faker::Number.between(from: 0, to: 1_000_000_000) }
    mobile_balance { Faker::Number.between(from: 0, to: 1_000_000_000) }
    iot_balance { Faker::Number.between(from: 0, to: 1_000_000_000) }
  end
end
