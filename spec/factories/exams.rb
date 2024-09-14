FactoryBot.define do
  factory :exam do
    title { Faker::Educator.course_name }
    start_date { Faker::Date.between(from: Date.today, to: 1.month.from_now) }
    end_date { Faker::Date.between(from: 1.month.from_now, to: 2.months.from_now) }

    trait :with_questions do
      transient do
        question_count { 3 }
      end

      after(:create) do |exam, evaluator|
        create_list(:question, evaluator.question_count, exam: exam)
      end
    end
  end
end
