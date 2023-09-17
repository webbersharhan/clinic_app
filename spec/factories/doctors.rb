FactoryBot.define do
  factory :doctor do
    first_name { "doc" }
    last_name { "lastname" }
    sequence(:email) { |n| "doc#{n}@example.com" }
    slot_duration_minutes { 15 }
  end
end
