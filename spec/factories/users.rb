FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "Password1" }
    password_confirmation { "Password1" }

    trait :with_invalid_email do
      email { "invalid_email" }
    end

    trait :with_invalid_password do
      password_digest { nil }
      password { "p" }
      password_confirmation { "p" }
    end

    trait :with_invalid_confirmation do
      password_digest { nil }
      password { "Password1" }
      password_confirmation { "Password2" }
    end
  end
end