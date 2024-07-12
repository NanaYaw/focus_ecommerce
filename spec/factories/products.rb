FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    stock { Faker::Number.between(from: 1, to: 10) }
    # sequence(:price) { |n| n * 100 }
    sequence(:price) { |n| n * 1.25 }
  end
end
