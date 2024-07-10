class User < ApplicationRecord
  before_save { self.email = email.downcase }

  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
