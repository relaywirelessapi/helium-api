# typed: false

FactoryBot.define do
  factory :helium_l2_iot_reward_share, class: "Relay::Helium::L2::IotRewardShare" do
    transient do
      file { create(:helium_l2_file) }
    end

    file_category { file.category }
    file_name { file.name }
    reward_type { "test-reward-type" }
    start_period { Time.current }
    end_period { Time.current + 1.day }
    hotspot_key { "test-hotspot-key" }
    beacon_amount { 10 }
    witness_amount { 5 }
    dc_transfer_amount { 2 }
    amount { 100 }
    unallocated_reward_type { "test-unallocated-reward" }
    deduplication_key { SecureRandom.uuid }
  end
end
