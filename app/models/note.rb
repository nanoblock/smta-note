class Note < ActiveRecord::Base
  belongs_to :users

  has_many :comment
  has_many :favorites, dependent: :destroy

  # searchable do
  #   text :title, :default_boost => 2
  #   text :desc
  # end 

  # validates :title, uniqueness: true
  # validates :desc, uniqueness: true

end
