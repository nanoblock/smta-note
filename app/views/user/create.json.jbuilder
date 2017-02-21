json.user do |json|
  json.id @user.id
  json.email @user.email
  json.name @user.name
  json.avatar_url @user.avatar_url
  json.updated_at @user.updated_at

  json.token do |token|
    token.id @token.id
    token.access_token @token.access_token
    token.activate @token.active
  end
end

# json.extract! @user, :id, :email, :name, :avatar_url, :updated_at
# json.extract! @token, :id, :access_token, :active