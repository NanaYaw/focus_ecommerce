class OrderSerializer < ActiveModel::Serializer
  attributes :id
  has_many :product_lines
  has_many :products, through: :product_lines
end
