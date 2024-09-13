FactoryBot.define do
  factory :question do
    content { Faker::Lorem.question }
    question_type { Question.question_types.keys.sample }
    points { Faker::Number.between(from: 1, to: 10) }
    association :exam
  end
end
