FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    username { "user"}
    first_name { "user" }
    middle_name { "middle" }
    last_name  { "Last" }
    phone { "0900000000" }
    gender { 1 }
    is_locked { false }
    password { "@Abc12345" }

    association :role

    trait :admin do
      sequence(:email) { |n| "admin#{n}@example.com" }
      username { "admin" }
      first_name { "admin" }
      middle_name { "" }
      last_name  { "" }
    end

    trait :agency do
      sequence(:email) { |n| "agency#{n}@example.com" }
      username { "agency" }
      first_name { "agency" }
      middle_name { "" }
      last_name  { "" }
    end

    trait :normal do
      sequence(:email) { |n| "user#{n}@example.com" }
      username { "user" }
      first_name { "user" }
      middle_name { "" }
      last_name  { "" }
    end
  end
end
