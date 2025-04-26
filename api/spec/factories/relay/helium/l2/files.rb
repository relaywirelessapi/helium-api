# typed: false

FactoryBot.define do
  factory :helium_l2_file, class: "Relay::Helium::L2::File" do
    definition_id { "test-category/test-prefix" }
    category { "test-prefix" }
    name { "test-name" }
    created_at { Time.current }
  end
end
