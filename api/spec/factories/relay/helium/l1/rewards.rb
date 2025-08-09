# typed: false

FactoryBot.define do
  factory :helium_l1_reward, class: "Relay::Helium::L1::Reward" do
    block { Faker::Number.between(from: 100_000, to: 2_000_000) }
    time { Faker::Number.between(from: 1_600_000_000, to: 1_700_000_000) }
    amount { Faker::Number.between(from: 1_000, to: 10_000_000) }
    type { [ "poc_witness", "poc_challengee", "poc_challenger", "consensus", "data_credits" ].sample }

    association :account, factory: :helium_l1_account
    association :gateway, factory: :helium_l1_gateway
    association :helium_transaction, factory: :helium_l1_transaction
  end
end
