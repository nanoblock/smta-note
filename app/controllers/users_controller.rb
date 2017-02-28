class UsersController < ApiBaseController
  skip_before_action :require_valid_token, :invalid_exsist_token, only: [:create, :activate, 
    :index, :reset_password_token, :reset_password_update, :reset_password] 


  # GET /users
  def index
    @user = User.all
    return render status: :no_content, nothing: true unless @user
    render 'jbuilder/user', status: :ok, formats: 'json'
  end

  # GET /users/1
  def show
    @user = current_user
    render 'jbuilder/user', status: :ok, formats: 'json' if @user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      @user.activate
      @token = Token.find_by_user_id @user.id
      Mailer.congratulation_email(@user).deliver_now
      render 'jbuilder/usertoken', status: :created, formats: 'json'
    else
      error_format(400, @user.errors)
    end

  end

  # PATCH/PUT /users/1
  def update
    user = current_user
    respond_to do |format|
      if user.update(user_params)
        render 'jbuilder/user', status: :ok, formats: 'json'
      else
        error_format(400, @user.errors)
      end
    end

  end

  # DELETE /users/1
  def destroy
    render status: :ok, nothing: true if current_user.destroy!
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
        @user.activate!
        # render "users/activate", :formats => [:html]
        return render status: :ok, nothing: true
    else
      error = @user.errors
      error_format(400, "#{error.first.first} #{error.first.second}")
        # return render nothing: true, status: :not_found
    end
  end

  def reset_password_api
    token = Token.find_by_access_token(@access_token)
    @user = User.find(token.user_id) if !token.nil?

    return error_format(404, "Parameter does not match user data") unless User.authenticate(@user.email, password_params[:old_password])
    @user.password = password_params[:password]
    @user.password_confirmation = password_params[:password_confirmation]
    if @user.valid?
      @user.save
      render 'jbuilder/user', status: :ok, formats: 'json'
    else
      return error_format(400, @user.errors)
    end
  end

  def reset_password
    user = User.find_by_email(params[:email])
    
    # token = Token.find_by_access_token(@access_token)
    # user = User.find(token.user_id) if !token.nil?
    return error_user_param unless user
    user.deliver_reset_password_instructions! if user

    # render 'jbuilder/user', status: :ok, formats: 'json'
    return render status: :ok, json: {"reset_token": user.reset_password_token}
    # render status: :ok, nothing: true
  end
 
  def reset_password_token
    set_token_user_from_params?
  end
 
  def reset_password_update
    return render status: :bad_request, nothing: true unless set_token_user_from_params?
 
    @user.password_confirmation = params[:user][:password_confirmation]
 
    if @user.change_password!(params[:user][:password])
      render 'jbuilder/user', status: :created, formats: 'json'
    else
      error_format(400, @user.errors)
    end
  end

  private

    def set_token(user_id)
      @token = Token.find_by_user_id(user_id)
    end

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

    def password_params
      params.require(:user).permit(:old_password, :password, :password_confirmation)
    end

    def set_token_user_from_params?
      @token = params[:id]
      @user = User.load_from_reset_password_token(params[:id])
 
      if @user.blank?
        return false
      else
        return true
      end
    end
end