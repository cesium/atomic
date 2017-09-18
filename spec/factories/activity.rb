FactoryGirl.define do
  factory :activity do
    name { Faker::BossaNova.song }
    location { Faker::Address.street_name }
    description { Faker::Hacker.say_something_smart }
    member_cost 0
    guest_cost 0
    start_date { Faker::Time.between(2.days.ago, 2.days.from_now, :all)}
    end_date { start_date + 1.hour }
  end
end
