FactoryBot.define do
  factory :comment do
    association :user
    association :answer
    comment { Faker::Lorem.characters(number: 30) }
  end
end
