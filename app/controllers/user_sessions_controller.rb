class UserSessionsController < ApiBaseController
  skip_before_action :require_valid_token, :invalid_exsist_token, :only => [:create]
 
  def create
    @user = login_email
    token = @user.activate
    @token = ApplicationController.helpers.current_token token.access_token
    @token.save!

    render 'jbuilder/usertoken', status: :ok, formats: 'json'
  end

  def destroy
    @token = Token.find_by_access_token(@access_token)

    if @token
      @user = User.find(@token.user_id)
      @user.inactivate
      render 'jbuilder/usertoken', status: :ok, formats: 'json'
    end
  end

  private
  def param
    return JSON.parse(request.body.string, {:symbolize_names => true})
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def login_email
    login(login_params[:email], login_params[:password])
    current_user
  end

  def login_name
    login(param[:user][:name], param[:user][:password])
  end

end