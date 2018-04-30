FactoryBot.define do
  factory :partner do
    name { Faker::BossaNova.song }
    description { Faker::Hacker.say_something_smart }
  end
end
