class Product < ApplicationRecord
  validates :price, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :stock, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def price=(value)
    value = (value * 100).to_i if value.is_a?(Float)
    super
  end
end
