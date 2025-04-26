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
    reward_data { { "key" => "value" } }
    epoch { Time.current }
    price { 100 }
    deduplication_key { SecureRandom.uuid }
  end
end
