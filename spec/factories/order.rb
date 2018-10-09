FactoryBot.define do
  factory :order do
    status ['new', 'completed'].sample
    association :seller, factory: :seller
    association :customer, factory: :customer
  end
end
