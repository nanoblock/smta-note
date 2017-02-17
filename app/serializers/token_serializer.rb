class TokenSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :access_token, :expires_at, :active, :updated_at
end
