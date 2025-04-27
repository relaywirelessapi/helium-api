# typed: false

FactoryBot.define do
  factory :helium_l2_mobile_reward_share, class: "Relay::Helium::L2::MobileRewardShare" do
    transient do
      file { create(:helium_l2_file) }
    end

    file_category { file.category }
    file_name { file.name }
    owner_key { "test-owner-key" }
    hotspot_key { "test-hotspot-key" }
    cbsd_id { "test-cbsd-id" }
    amount { 100 }
    start_period { Time.current }
    end_period { Time.current + 1.day }
    reward_type { "gateway_reward" }
    dc_transfer_reward { 10 }
    poc_reward { 5 }
    subscriber_id { "test-subscriber-id" }
    subscriber_reward { 20 }
    discovery_location_amount { 15 }
    unallocated_reward_type { "test-unallocated-reward" }
    service_provider_id { "test-service-provider-id" }
    deduplication_key { SecureRandom.uuid }
    base_coverage_points_sum { BigDecimal("100.0") }
    boosted_coverage_points_sum { BigDecimal("150.0") }
    base_reward_shares { BigDecimal("50.0") }
    boosted_reward_shares { BigDecimal("75.0") }
    base_poc_reward { 25 }
    boosted_poc_reward { 35 }
    coverage_object { "\x00" }
    location_trust_score_multiplier { BigDecimal("1.0") }
    speedtest_multiplier { BigDecimal("1.0") }
    sp_boosted_hex_status { "0" }
    oracle_boosted_hex_status { "0" }
    entity { "test-entity" }
    service_provider_amount { 30 }
    matched_amount { 40 }
    seniority_timestamp { Time.current }
  end
end
