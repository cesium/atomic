FactoryBot.define do
  factory :article do
    name { Faker::BossaNova.song }
    text { Faker::Hacker.say_something_smart }
  end
end
