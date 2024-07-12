# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(
  name: "name",
  email: "gus@example.com",
  password: "password",
)

10.times.each do
  Product.create(
    name: Faker::Coffee.name,
    stock: Faker::Number.between(from: 1, to: 10),
    price: Faker::Number.between(from: 100, to: 500)
  )
end

2.times.each do
  order = Order.create!(
    user: User.first,
  )

  5.times.each do
    ProductLine.create(
      quantity: Faker::Number.between(from: 1, to: 3),
      product_id: Product.all.sample.id,
      order_id: order.id
    )
  end
end