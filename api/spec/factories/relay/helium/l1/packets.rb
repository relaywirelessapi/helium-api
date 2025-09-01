# typed: false

FactoryBot.define do
  factory :helium_l1_packet, class: "Relay::Helium::L1::Packet" do
    block { Faker::Number.between(from: 100_000, to: 2_000_000) }
    time { Faker::Number.between(from: 1_600_000_000, to: 1_700_000_000) }
    num_packets { Faker::Number.between(from: 1, to: 1000) }
    num_dcs { Faker::Number.between(from: 1, to: 2000) }

    association :gateway, factory: :helium_l1_gateway
    association :helium_transaction, factory: :helium_l1_transaction
  end
end
