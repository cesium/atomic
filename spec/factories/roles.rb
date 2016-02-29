FactoryGirl.define do
  factory :role do
    title "Diretor"
    department FactoryGirl.create :department
  end

end
