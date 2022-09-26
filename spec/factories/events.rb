FactoryBot.define do
  factory :event do
    association :user
    title { 'Чебуреки от Чебурашек' }
    address { 'Чебоксары' }
    datetime { DateTime.parse('01.01.2024 12:00') }
  end
end
