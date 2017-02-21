json.set! :comment do 
  json.array!(@comments) do |comments|
    json.extract! comments, :id, :note_id, :contents, :created_at, :updated_at
  end
end