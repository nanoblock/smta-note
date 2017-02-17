module ApplicationHelper

  def current_user
    token = Token.find_by_access_token(request.headers[:HTTP_ACCESS_TOKEN])
     User.find(token.user_id) if !token.nil?
  end

  def current_token
     Token.find_by_access_token(request.headers[:HTTP_ACCESS_TOKEN])
  end
  
end
