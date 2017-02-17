class ApiBaseController < ApplicationController
  before_action :invalid_exsist_token, only: [:require_valid_token]
  before_action :require_valid_token

  private

  def require_valid_token
    @access_token = request.headers[:HTTP_ACCESS_TOKEN]
    if !User.login?(@access_token)
      respond_to do |format|
        format.json { render nothing: true, status: :unauthorized }
      end
    end
  end

  def invalid_exsist_token
    token = request.headers[:HTTP_ACCESS_TOKEN]

    unless token
      return render status: :bad_request, noting: true 
    else
      return token
    end
  end

end