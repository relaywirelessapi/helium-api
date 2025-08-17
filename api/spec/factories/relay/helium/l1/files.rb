# typed: false

FactoryBot.define do
  factory :helium_l1_file, class: "Relay::Helium::L1::File" do
    file_type { Relay::Helium::L1::File::IMPORTER_KLASSES.keys.sample }
    file_name { "#{file_type}_#{Faker::Number.between(from: 1, to: 999999)}.csv.gz" }
  end
end
