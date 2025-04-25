# typed: false

FactoryBot.define do
  factory :helium_l2_mobile_reward_share, class: "Relay::Helium::L2::MobileRewardShare" do
    reward_type { "test-reward-type" }
    start_period { Time.current }
    end_period { Time.current + 1.day }
    hotspot_key { "test-hotspot-key" }
    cbsd_id { "test-cbsd-id" }
    amount { 100 }
    dc_transfer_reward { 10 }
    poc_reward { 5 }
    subscriber_id { "test-subscriber-id" }
    subscriber_reward { 20 }
    discovery_location_amount { 15 }
    unallocated_reward_type { "test-unallocated-reward" }
    service_provider_id { "test-service-provider-id" }
    deduplication_key { SecureRandom.uuid }
    base_coverage_points_sum { 100.0 }
    boosted_coverage_points_sum { 150.0 }
    base_reward_shares { 50.0 }
    boosted_reward_shares { 75.0 }
    base_poc_reward { 25 }
    boosted_poc_reward { 35 }
    seniority_timestamp { Time.current.to_i }
    location_trust_score_multiplier { 1.0 }
    speedtest_multiplier { 1.0 }
    sp_boosted_hex_status { 0 }
    oracle_boosted_hex_status { 0 }
    entity { "test-entity" }
    service_provider_amount { 30 }
    matched_amount { 40 }
  end
end
