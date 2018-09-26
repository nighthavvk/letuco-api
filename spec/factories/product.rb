FactoryBot.define do
  factory :product do
    name { Faker::Food.unique.dish }
    association :shop, factory: :shop
  end
end
