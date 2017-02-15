class UserSessionsController < ApiBaseController
  skip_before_action :require_valid_token, :only => [:create]
 
  def create
    @user = login_email || @user = login_name

    unless @user
      return render status: :not_found, nothing: true
    end

    token = @user.activate
    @access_token = token.access_token

    render status: :ok, json: @access_token
  end

  def destroy
    token = Token.find_by_access_token(@access_token)
    if token
      user = User.find(token.user_id)
      user.inactivate
      respond_to do |format|
        format.json { render nothing: true, status: :ok }
      end
    end
  end

  private
  def login_email
    login(login_email_params[:email], login_email_params[:password])
  end

  def login_name
    login(login_name_params[:name], login_name_params[:password])
  end

  def login_email_params
    params.require(:user).permit(:email, :password)
  end

  def login_name_params
    params.require(:user).permit(:name, :password)
  end

end