class OrderSerializer < ActiveModel::Serializer
  attributes :id, :created_at
  has_many :product_lines
  # has_many :products, through: :product_lines, serializer: ProductSerializer

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
