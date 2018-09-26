FactoryBot.define do
  factory :sign_up_params, class: Hash do
    defaults = {
      email: Faker::Internet.unique.email,
      password: '11112222',
      password_confirmation: '11112222'
    }
    initialize_with{ defaults.merge(attributes) }
  end
end
