class Note < ActiveRecord::Base
  belongs_to :users

  has_many :comment
  has_many :favorites, dependent: :destroy

  # validates :title, uniqueness: true
  # validates :desc, uniqueness: true

end
