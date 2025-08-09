# typed: false

FactoryBot.define do
  factory :helium_l1_transaction_actor, class: "Relay::Helium::L1::TransactionActor" do
    actor_role { [ "packet_receiver", "challenger", "challengee", "witness", "payer", "payee" ].sample }
    block { Faker::Number.between(from: 100_000, to: 2_000_000) }

    association :helium_transaction, factory: :helium_l1_transaction
    association :actor, factory: :helium_l1_account
  end
end
