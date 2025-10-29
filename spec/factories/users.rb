FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name { "user" }
    last_name  { "Last" }
    phone { "0900000000" }
    gender { 1 }
    is_locked { false }
    password { "@Abc12345" }

    association :role

    trait :admin do
      sequence(:email) { |n| "admin#{n}@example.com" }
      first_name { "admin" }
      last_name  { "" }
    end

    trait :agency do
      sequence(:email) { |n| "agency#{n}@example.com" }
      first_name { "agency" }
      last_name  { "" }
    end

    trait :normal do
      sequence(:email) { |n| "user#{n}@example.com" }
      first_name { "user" }
      last_name  { "" }
    end
  end
end
