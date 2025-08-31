# typed: false

FactoryBot.define do
  factory :helium_l2_reward_manifest, class: "Relay::Helium::L2::RewardManifest" do
    transient do
      file { create(:helium_l2_file) }
    end

    file_category { file.category }
    file_name { file.name }
    written_files { [ "file1.json", "file2.json" ] }
    start_timestamp { Time.current }
    end_timestamp { Time.current + 1.day }
    reward_data do
      {
        "token" => "mobile_reward_token_hnt",
        "reward_type" => "mobile",
        "poc_bones_per_reward_share" => "31358.655119335628677836557476",
        "service_provider_promotions" => [
          {
            "promotions" => [
              {
                "end_ts" => "2025-12-31T00:00:00.000Z",
                "entity" => "Referral Elite",
                "shares" => 100,
                "start_ts" => "2024-10-29T00:00:00.000Z"
              }
            ],
            "service_provider" => "helium_mobile",
            "incentive_escrow_fund_bps" => 792
          }
        ],
        "boosted_poc_bones_per_reward_share" => "31358.655119335628677836557476"
      }
    end
    epoch { Time.current }
    price { 100 }
    deduplication_key { SecureRandom.uuid }
  end
end
