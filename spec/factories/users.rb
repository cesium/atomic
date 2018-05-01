FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    phone_number { Faker::Number.number(9) }
    email { Faker::Internet.free_email(name) }
    hashname { (name + phone_number + email).hash }
  end
end
