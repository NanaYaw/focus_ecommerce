class ProductLineSerializer < ActiveModel::Serializer
  attributes :id, :quantity
  belongs_to :order
  belongs_to :product
end
