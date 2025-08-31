# typed: false

FactoryBot.define do
  factory :helium_l2_reward_manifest_file, class: "Relay::Helium::L2::RewardManifestFile" do
    association :reward_manifest, factory: :helium_l2_reward_manifest
    sequence(:file_name) { |n| "test-name-#{n}" }
  end
end
