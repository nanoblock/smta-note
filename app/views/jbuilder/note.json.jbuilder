json.note do |json|
  json.extract! @note, :id, :user_id, :title, :desc, :created_at, :updated_at
end