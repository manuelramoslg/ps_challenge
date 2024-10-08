FactoryBot.define do
  factory :user_exam do
    association :user
    association :exam
    status { :in_progress }
    total_score { nil }

    trait :with_user_answers do
      transient do
        user_answer_count { 3 }
      end

      after(:create) do |user_exam, evaluator|
        create_list(:user_answer, evaluator.user_answer_count, user_exam: user_exam)
      end
    end

    trait :with_score do
      total_score { Faker::Number.between(from: 0, to: 100) }
    end

    trait :completed do
      status { :completed }
      total_score { 80 }
    end
  end
end
