FactoryBot.define do
  factory :question do
    content { Faker::Lorem.question }
    question_type { Question.question_types.keys.sample }
    is_scorable { Faker::Boolean.boolean }
    points { Faker::Number.between(from: 1, to: 10) }
    exam

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
