FactoryBot.define do
  factory :partner do
    name { Faker::BossaNova.song }
    description { Faker::Hacker.say_something_smart }
    logo { Faker::Avatar.image("cesium", "300x300", "jpg") }
  end
end
