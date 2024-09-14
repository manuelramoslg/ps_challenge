FactoryBot.define do
  factory :user_answer do
    association :user_exam
    association :question
    content { Faker::Lorem.sentence }

    trait :for_free_text do
      association :question, factory: [ :question, :free_text ]
      content { Faker::Lorem.paragraph }
    end

    trait :for_multiple_choice do
      association :question, factory: [ :question, :multiple_choice ]
      content { [ Faker::Number.number(digits: 1), Faker::Number.number(digits: 1) ].map(&:to_s) }
    end

    trait :for_single_choice do
      association :question, factory: [ :question, :single_choice ]
      content { Faker::Number.number(digits: 1).to_s }
    end
  end
end
