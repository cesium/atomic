FactoryBot.define do
  factory :registration do
    activity
    user
    confirmed { Faker::Boolean.boolean }
  end
end
