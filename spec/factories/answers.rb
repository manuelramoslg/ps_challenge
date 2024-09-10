FactoryBot.define do
  factory :answer do
    content { Faker::Lorem.sentence }
    is_correct { Faker::Boolean.boolean }
    question
  end
end
