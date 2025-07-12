# typed: false

FactoryBot.define do
  factory :hotspot, class: "Relay::Helium::L2::Hotspot" do
    address { Faker::Blockchain::Solana.address }
    nft_address { Faker::Blockchain::Solana.address }
    ecc_key { Faker::Blockchain::Solana.address }
    name { Faker::Internet.unique.domain_word }
    association :maker, factory: :helium_l2_maker

    trait :iot do
      iot_info_address { Faker::Blockchain::Solana.address }
      iot_bump_seed { Faker::Number.between(from: 0, to: 255) }
      iot_location { Faker::Number.number(digits: 18) }
      iot_is_full_hotspot { Faker::Boolean.boolean }
      iot_num_location_asserts { Faker::Number.between(from: 0, to: 10) }
      iot_is_active { Faker::Boolean.boolean }
      iot_dc_onboarding_fee_paid { Faker::Number.between(from: 0, to: 10_000_000) }
      iot_elevation { Faker::Number.between(from: 0, to: 100) }
      iot_gain { Faker::Number.between(from: 0, to: 100) }
    end

    trait :mobile do
      mobile_info_address { Faker::Blockchain::Solana.address }
      mobile_bump_seed { Faker::Number.between(from: 0, to: 255) }
      mobile_location { Faker::Number.number(digits: 18) }
      mobile_is_full_hotspot { Faker::Boolean.boolean }
      mobile_num_location_asserts { Faker::Number.between(from: 0, to: 10) }
      mobile_is_active { Faker::Boolean.boolean }
      mobile_dc_onboarding_fee_paid { Faker::Number.between(from: 0, to: 10_000_000) }
      mobile_device_type { Relay::Helium::L2::Hotspot::DEVICE_TYPES.sample }
      mobile_antenna { Faker::Number.between(from: 0, to: 100) }
      mobile_azimuth { Faker::Number.between(from: 0, to: 100) }
      mobile_mechanical_down_tilt { Faker::Number.between(from: 0, to: 100) }
      mobile_electrical_down_tilt { Faker::Number.between(from: 0, to: 100) }
    end
  end
end
