FactoryBot.define do
  factory :article do
    association :user
    title { Faker::Lorem.characters(number: 10) }
    content {Faker::Lorem.characters(number: 50)}
    area { Faker::Lorem.characters(number: 5)}
    category { Faker::Lorem.characters(number: 5)}
  end
end