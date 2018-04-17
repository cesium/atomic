FactoryBot.define do
  factory :partner do
    name { Faker::BossaNova.song }
    benefits { Faker::Hacker.say_something_smart }
    poster { Faker::Avatar.image("cesium", "300x300", "jpg") }
  end
end
