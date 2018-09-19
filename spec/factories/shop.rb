FactoryBot.define do
  factory :shop do
    name { 'CooP' }
    association :account, factory: :account
  end
end
