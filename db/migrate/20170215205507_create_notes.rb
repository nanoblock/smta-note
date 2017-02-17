class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.text :desc
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
