# typed: false

FactoryBot.define do
  factory :helium_l2_iot_reward_share, class: "Relay::Helium::L2::IotRewardShare" do
    reward_type { "test-reward-type" }
    start_period { Time.current }
    end_period { Time.current + 1.day }
    hotspot_key { "test-hotspot-key" }
    beacon_amount { 10 }
    witness_amount { 5 }
    dc_transfer_amount { 2 }
    amount { 100 }
    unallocated_reward_type { "test-unallocated-reward" }
  end
end
