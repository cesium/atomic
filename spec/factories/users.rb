FactoryBot.define do
  factory :user do
    name do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name

      "#{first_name} #{last_name}"
    end

    sequence(:account_number)
    sequence(:student_id)

    phone_number { Faker::Number.number(9) }
    city { Faker::Address.city }
    birthdate { Faker::Date.between(30.years.ago, 18.years.ago) }

    email { Faker::Internet.free_email(name) }
    password { Faker::Internet.password }
  end
end
