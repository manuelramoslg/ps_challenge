FactoryBot.define do
  factory :user_answer do
    content { Faker::Lorem.sentence }
    association :exam_attempt
    association :question
    association :answer

    trait :for_free_text do
      association :question, factory: [ :question, :free_text ]
      answer { nil }
    end

    trait :for_multiple_choice do
      association :question, factory: [ :question, :multiple_choice ]
    end

    trait :for_single_choice do
      association :question, factory: [ :question, :single_choice ]
    end
  end
end
