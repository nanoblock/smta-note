module ApplicationHelper

  # def current_user(access_token = request.headers[:HTTP_ACCESS_TOKEN])
  #   token = Token.find_by_access_token(access_token)
  #   @user = User.find(token.user_id) if !token.nil?
  # end

  def current_token(access_token = request.headers[:HTTP_ACCESS_TOKEN])
    @token = Token.find_by_access_token(access_token)
  end

  def json_parser(string)
    return JSON.parse(string, {:symbolize_names => true})
  end

end
