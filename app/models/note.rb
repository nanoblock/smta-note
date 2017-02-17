class Note < ActiveRecord::Base
  belongs_to :users

  has_many :comment

  validates :title, uniqueness: true
  validates :desc, uniqueness: true
  
end
