FactoryGirl.define do
  factory :publication do
    title { Faker::Hipster.sentence }
    body { Faker::Lorem.paragraph(4) }
  end

  factory :post, class: Post, parent: :publication do
  end

  factory :article, class: Article, parent: :publication do
  end
end
