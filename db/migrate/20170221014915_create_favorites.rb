class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.belongs_to :note
      t.integer :user_id
      # , null: false
      t.timestamp :created_at
    end
  end
end
