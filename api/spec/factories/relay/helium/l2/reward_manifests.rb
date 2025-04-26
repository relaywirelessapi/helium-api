# typed: false

FactoryBot.define do
  factory :helium_l2_reward_manifest, class: "Relay::Helium::L2::RewardManifest" do
    written_files { [ "file1.json", "file2.json" ] }
    start_timestamp { Time.current }
    end_timestamp { Time.current + 1.day }
    reward_data { { "key" => "value" } }
    epoch { Time.current }
    price { 100 }
    deduplication_key { SecureRandom.uuid }
  end
end
