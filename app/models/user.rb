class User < ApplicationRecord
  before_save { self.email = email.downcase }

  enum role: Hash[
    UserRole::ROLES.collect { |role| [role, role] }
  ], _prefix: true

  has_secure_password
  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }

  has_many :orders
  has_many :product_lines, through: :orders

  def orders_with_productlines_products
    orders.includes(product_lines: :product).map do |order|
      {
        order_id: order.id,
        order_date: order.created_at,
        product_lines: order.product_lines.map do |product_line|
          {
            product_line_id: product_line.id,
            quantity: product_line.quantity,
            product: {
              product_id: product_line.product.id,
              name: product_line.product.name,
              price: product_line.product.price,
              stock: product_line.product.stock
            }
          }
        end
      }
    end
  end
end
