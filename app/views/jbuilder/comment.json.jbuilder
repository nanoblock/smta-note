json.comment do |json|
  json.extract! @comment, :id, :note_id, :contents, :created_at, :updated_at
end