class User < ApplicationRecord
  before_save { self.email = email.downcase }

  has_secure_password
  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }

  has_many :orders
  has_many :product_lines, through: :order
  # has_many :products, through: :orders
end
