json.user do |json|
  json.extract! @user, :id, :email, :name, :avatar_url, :updated_at
end