class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :avatar_url, :updated_at
  has_many :token
   # :crypted_password, :salt
end