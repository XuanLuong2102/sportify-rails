FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "role_#{n}" }

    trait :admin  do
      name { "admin" }
    end

    trait :agency do
      name { "agency" }
    end

    trait :user do
      name { "user" }
    end
  end
end
