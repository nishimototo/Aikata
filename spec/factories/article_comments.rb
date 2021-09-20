FactoryBot.define do
  factory :article_comment do
    association :user
    association :article
    comment {Faker::Lorem.characters(number: 30)}
  end
end