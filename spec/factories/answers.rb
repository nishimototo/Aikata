FactoryBot.define do
  factory :answer do
    association :user
    association :theme
    content {Faker::Lorem.characters(number: 50)}
  end
end