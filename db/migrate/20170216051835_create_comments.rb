class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :contents
      t.belongs_to :note
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
