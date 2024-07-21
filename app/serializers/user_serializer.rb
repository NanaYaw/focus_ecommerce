class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :role, :email, :created_at

  has_many :orders
end
