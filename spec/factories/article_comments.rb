FactoryBot.define do
  factory :article_comment do
    association :user
    comment {Faker::Lorem.characters(number: 30)}
  end
end