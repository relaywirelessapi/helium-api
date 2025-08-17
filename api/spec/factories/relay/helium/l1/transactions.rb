# typed: false

FactoryBot.define do
  factory :helium_l1_transaction, class: "Relay::Helium::L1::Transaction" do
    block { Faker::Number.between(from: 100_000, to: 2_000_000) }
    transaction_hash { Faker::Internet.password(min_length: 40, max_length: 60) }
    type { [ "poc_request_v1", "poc_receipts_v1", "payment_v1", "add_gateway_v1", "assert_location_v1" ].sample }
    fields { {
      "fee" => Faker::Number.between(from: 0, to: 100_000),
      "hash" => Faker::Internet.password(min_length: 40, max_length: 60),
      "type" => "poc_request_v1",
      "version" => Faker::Number.between(from: 1, to: 3),
      "block_hash" => Faker::Internet.password(min_length: 40, max_length: 60),
      "challenger" => Faker::Blockchain::Solana.address,
      "secret_hash" => Faker::Internet.password(min_length: 40, max_length: 60),
      "onion_key_hash" => Faker::Internet.password(min_length: 40, max_length: 60),
      "challenger_owner" => Faker::Blockchain::Solana.address,
      "challenger_location" => Faker::Number.hexadecimal(digits: 16)
    } }
    time { Faker::Number.between(from: 1_600_000_000, to: 1_700_000_000) }
  end
end
