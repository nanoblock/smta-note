json.user do |json|
  json.extract! @user, :id, :email, :avatar_url, :updated_at
end