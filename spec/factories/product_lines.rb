FactoryBot.define do
  factory :product_line do
    quantity { Faker::Number.between(from: 1, to: 10) }
    association :order
    association :product
  end
end