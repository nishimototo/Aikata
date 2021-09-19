FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: ) }
    email { Faker::Internet.email }
    introduction { Faker::Lorem.characters(number: 20) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end