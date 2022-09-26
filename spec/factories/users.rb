FactoryBot.define do
  factory :user do
    name { "Господин(жа) #{rand(999)}" }
    sequence(:email) { |n| "test_#{n}@test.org" }
    after(:build) { |u| u.password_confirmation = u.password = 'qwerty' }
  end
end
