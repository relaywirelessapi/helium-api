# typed: false

FactoryBot.define do
  factory :helium_l1_dc_burn, class: "Relay::Helium::L1::DcBurn" do
    association :actor, factory: :helium_l1_account
    association :helium_transaction, factory: :helium_l1_transaction

    block { Faker::Number.between(from: 100_000, to: 2_000_000) }
    type { [ "assert_location", "add_gateway", "fee", "consensus", "data_credits" ].sample }
    amount { Faker::Number.between(from: 0, to: 10_000_000) }
    oracle_price { Faker::Number.between(from: 1_000_000_000, to: 2_000_000_000) }
    time { Faker::Number.between(from: 1_600_000_000, to: 1_700_000_000) }
  end
end
