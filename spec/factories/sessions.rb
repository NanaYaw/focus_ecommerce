FactoryBot.define do
  factory :session do
    association :user
    token { Faker::Alphanumeric.alphanumeric(number: 64) }
  end
end
