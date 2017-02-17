class Comment < ActiveRecord::Base
  belongs_to :note

  validates :contents, uniqueness: true
  validates :user_id, uniqueness: true
end
