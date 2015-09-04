FactoryGirl.define do
  factory :user do
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name

    name "#{first_name} #{last_name}"
    sequence(:account_number)
    sequence(:student_id)
    phone_number Faker::Number.number(9)
    street Faker::Address.street_address
    city Faker::Address.city
    birthdate Faker::Date.between(30.years.ago, 18.years.ago)
  end

  factory :member, parent: :user do
  end

  factory :buddy, parent: :user do
  end
end
