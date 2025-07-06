# typed: false

FactoryBot.define do
  factory :helium_l2_maker, class: "Relay::Helium::L2::Maker" do
    address { Faker::Blockchain::Solana.address }
    update_authority { Faker::Blockchain::Solana.address }
    issuing_authority { Faker::Blockchain::Solana.address }
    name { Faker::Name.name }
    bump_seed { Faker::Number.between(from: 0, to: 255) }
    collection { Faker::Blockchain::Solana.address }
    merkle_tree { Faker::Blockchain::Solana.address }
    collection_bump_seed { Faker::Number.between(from: 0, to: 255) }
    dao { Faker::Blockchain::Solana.address }
  end
end
