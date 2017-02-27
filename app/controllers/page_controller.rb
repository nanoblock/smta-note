class PageController < ApplicationController
  skip_before_action :invalid_exsist_token, :require_valid_token
  
  def password_reset
    
  end
end
