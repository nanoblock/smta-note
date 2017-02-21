class ApiBaseController < ApplicationController
  include ApplicationHelper

  before_action :invalid_exsist_token, :require_valid_token

  def error_format(code, status, message)
    return render status: status.to_sym, json: error_format_json(code, status, message)
  end

  def error_format_json(code, status, message)
    json = {
      "code": code,
      "status": status,
      "message": message
    }
    return json.to_json
  end

  private

  def require_valid_token
    return render status: :unauthorized, json: error_format(401, Rack::Utils::HTTP_STATUS_CODES[401], "Invalid token") if invalid_token @access_token
    return render status: :unauthorized, json: error_format(401, Rack::Utils::HTTP_STATUS_CODES[401], "User do not login") if invalid_lagin @access_token
  end

  def invalid_exsist_token
    @access_token = request.headers[:HTTP_ACCESS_TOKEN]

    if !@access_token
      return render status: :bad_request, noting: true 
    else
      return @access_token
    end
  end

  def invalid_token(token)
    return true if Token.find_by_access_token(token).nil?
  end

  def invalid_lagin(token)
    return true if !User.login?(token)
  end

  def error_not_found
    error_format(404, Rack::Utils::HTTP_STATUS_CODES[404], "Not found data")
  end

  def error_user_param(user_id = params[:user_id].to_i)
    unless current_user.id.to_i == user_id
      error_format(400, Rack::Utils::HTTP_STATUS_CODES[400], "Parameter does not match user data") 
    end
  end

end