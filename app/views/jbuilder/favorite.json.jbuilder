json.favorite do |json|
  json.extract! @favorite, :id, :note_id, :user_id, :created_at
end