FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }

    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :manager do
      after(:create) { |user| user.add_role(:manager) }
    end
  end
end
