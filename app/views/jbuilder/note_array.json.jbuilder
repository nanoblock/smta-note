json.set! :note do 
  json.array!(@note) do |note|
    json.extract! note, :id, :user_id, :title, :desc, :created_at, :updated_at
    json.favorite note.favorites.length
  end
end

# json.user do |user|
#   json.id @user.id
#   json.email @user.email
#   # json.name @user.name
#   json.avatar_url @user.avatar_url
#   json.updated_at @user.updated_at

#   json.token do |token|
#     token.id @token.id
#     token.user_id @token.user_id
#     token.access_token @token.access_token
#     token.activate @token.active
#   end
# end