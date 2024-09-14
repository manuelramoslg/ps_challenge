FactoryBot.define do
  factory :question do
    content { Faker::Lorem.question }
    question_type { Question.question_types.keys.sample }
    points { Faker::Number.between(from: 1, to: 10) }
    association :exam

    trait :with_answers do
      transient do
        answer_count { 4 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answer_count, question: question)
      end
    end

    trait :free_text do
      question_type { :free_text }
    end

    trait :multiple_choice do
      question_type { :multiple_choice }
    end

    trait :single_choice do
      question_type { :single_choice }
    end
  end
end
