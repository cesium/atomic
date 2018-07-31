FactoryBot.define do
  factory :job do
    position { Faker::Job.title }
    company { Faker::Company.name }
    location { Faker::Address.street_name }
    description { Faker::Hacker.say_something_smart }
    link { Faker::Internet.url }
    contact { Faker::Internet.safe_email }
  end
end
