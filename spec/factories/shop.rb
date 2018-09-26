FactoryBot.define do
  factory :shop do
    name { Faker::Company.unique.name }
    association :account, factory: :account
  end
end
