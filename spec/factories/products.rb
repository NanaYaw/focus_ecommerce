FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price }
    stock { Faker::Number.between(from: 1, to: 7) }
  end
end