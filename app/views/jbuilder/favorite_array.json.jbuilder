json.set! :favorite do 
  json.array!(@favorites) do |favorites|
    json.extract! favorites, :id, :note_id, :user_id, :created_at
  end
end