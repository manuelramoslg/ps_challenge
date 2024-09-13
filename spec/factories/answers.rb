FactoryBot.define do
  factory :answer do
    content { Faker::Lorem.sentence }
    correct { [ true, false ].sample }
    association :question
  end
end
