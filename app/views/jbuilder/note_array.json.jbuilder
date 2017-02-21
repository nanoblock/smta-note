json.set! :note do 
  json.array!(@note) do |note|
    json.extract! note, :id, :user_id, :title, :desc, :created_at, :updated_at
  end
end