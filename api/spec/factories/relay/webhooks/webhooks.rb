# typed: false

FactoryBot.define do
  factory :webhook, class: "Relay::Webhook" do
    payload { { "test" => "test" } }
  end
end
