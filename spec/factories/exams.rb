FactoryBot.define do
  factory :exam do
    title { Faker::Educator.course_name }
    description { Faker::Lorem.paragraph }
    start_date { 1.day.from_now }
    end_date { 7.days.from_now }
  end
end
