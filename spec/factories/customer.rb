FactoryBot.define do
  factory :customer do
    name { Faker::Food.unique.dish }
    association :account, factory: :account
  end
end
