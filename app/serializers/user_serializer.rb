class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :cryped_password, :salt
end
