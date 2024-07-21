class Order < ApplicationRecord
  belongs_to :user
  has_many :product_lines
  has_many :products, through: :product_lines
end
