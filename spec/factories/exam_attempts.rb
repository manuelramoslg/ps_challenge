FactoryBot.define do
  factory :exam_attempt do
    start_time { Time.current }
    end_time { 1.hour.from_now }
    score { Faker::Number.between(from: 0, to: 100) }
    user
    exam
  end
end
