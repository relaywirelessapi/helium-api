# typed: false

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 12) }
    confirmed_at { Time.current }
  end
end
