# typed: false

FactoryBot.define do
  factory :helium_l2_file, class: "Relay::Helium::L2::File" do
    definition_id { "test-category/test-prefix" }
    s3_key { "test-key" }
    created_at { Time.current }
  end
end
