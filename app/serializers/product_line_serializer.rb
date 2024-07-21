class ProductLineSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product
  belongs_to :order
  belongs_to :product
end
