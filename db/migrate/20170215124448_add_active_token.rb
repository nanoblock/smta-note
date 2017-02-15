class AddActiveToken < ActiveRecord::Migration
  def change
    add_column :tokens, :active, :boolean
  end
end
