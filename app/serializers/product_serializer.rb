class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :stock
  has_many :product_lines
end
