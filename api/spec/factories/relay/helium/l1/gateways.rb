# typed: false

FactoryBot.define do
  factory :helium_l1_gateway, class: "Relay::Helium::L1::Gateway" do
    address { Faker::Blockchain::Solana.address }
    location { Faker::Number.hexadecimal(digits: 16) }
    last_poc_challenge { Faker::Number.between(from: 1_000_000, to: 2_000_000) }
    last_poc_onion_key_hash { Faker::Internet.password(min_length: 20, max_length: 50) }
    witnesses { {} }
    first_block { Faker::Number.between(from: 100_000, to: 2_000_000) }
    last_block { Faker::Number.between(from: 1_500_000, to: 2_000_000) }
    nonce { Faker::Number.between(from: 0, to: 100) }
    name { "#{Faker::Adjective.positive}-#{Faker::Color.color_name}-#{Faker::Creature::Animal.name}" }
    first_timestamp { Faker::Time.between(from: 2.years.ago, to: 1.year.ago) }
    reward_scale { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    elevation { Faker::Number.between(from: 0, to: 100) }
    gain { Faker::Number.between(from: 0, to: 100) }
    location_hex { Faker::Number.hexadecimal(digits: 16) }
    mode { [ "full", "dataonly" ].sample }

    association :owner, factory: :helium_l1_account
    association :payer, factory: :helium_l1_account
  end
end
