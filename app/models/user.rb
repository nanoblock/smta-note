class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :tokens, dependent: :destroy
  has_many :notes, dependent: :destroy
 
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
 
  validates :email, uniqueness: true
  validates :name, uniqueness: true
 
  def self.login?(access_token)
    token = Token.find_by_access_token(access_token)
    return false if !token || !token.before_expired? || !token.active
    return !self.find(token.user_id).nil?
  end
 
  def activate
    if !token
      return Token.create(user_id: self.id)
    else
      if !token.active
        token.set_active
        token.save
      end
      if !token.before_expired?
        token.set_expiration
        token.save
      end
      return token
    end
  end
 
  def inactivate
    token.active = false
    token.save
  end
 
  private

  def token
    @token ||= Token.find_by_user_id(self.id)
  end

end
