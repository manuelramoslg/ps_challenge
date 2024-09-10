FactoryBot.define do
  factory :role do
    name { Role::ALLOWED_NAMES.sample }
  end
end
