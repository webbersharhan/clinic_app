FactoryBot.define do
  factory :patient do
    first_name { "Webb" }
    last_name { "Sharh" }
    sequence(:email) { |n| "test#{n}@example.com" }
  end
end
