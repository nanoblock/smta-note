class Favorite < ActiveRecord::Base
  after_initialize :created_time
  belongs_to :note

  def created_time
    self.created_at = DateTime.now
  end

end
