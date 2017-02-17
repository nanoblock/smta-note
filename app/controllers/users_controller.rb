class UsersController < ApiBaseController
  skip_before_action :require_valid_token, only: [:create, :activate, 
    :index, :reset_password, :reset_password_token, :reset_password_update] 


  # GET /users
  def index
    users = User.all
    return render status: :no_content, nothing: true unless users

    render status: :ok, json: users
  end

  # GET /users/1
  def show
    user = current_user
    render status: :ok, json: user if user
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
      # render status: :created, json: {"user": @user, "token": set_token(@user.id)}
      render status: :created, json: @user
    else
      render nothing: true, status: :bad_request
    end

  end

  # PATCH/PUT /users/1
  def update
    user = current_user
    respond_to do |format|
      if user.update(user_params)
        format.json { render json: user }
      else
        format.json { render json: user.errors, status: :unprocessable_entity }
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
        render status: :ok, nothing: true
    else
        render nothing: true, status: :not_found
    end
  end

  def reset_password
    @user = User.find_by_email(params[:email])
    @user.deliver_reset_password_instructions! if @user
    render status: :ok, nothing: true
  end
 
  def reset_password_token
    set_token_user_from_params?
  end
 
  def reset_password_update
    return render status: :bad_request, nothing: true unless set_token_user_from_params?
 
    @user.password_confirmation = params[:user][:password_confirmation]
 
    if @user.change_password!(params[:user][:password])
      # render status: :ok, json: {"user": @user, "token": set_token(@user.id) }
      render status: :created, json: @user
    else
      render status: :bad_request, nothing: true
    end
  end

  private
    # def set_user
    #   return render nothing: true, status: :bad_request unless params[:id]
    #   @user = User.find(params[:id])
    # end

    def set_token(user_id)
      @token = Token.find_by_user_id(user_id)
    end

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

    def set_token_user_from_params?
      @token = params[:id]
      @user = User.load_from_reset_password_token(params[:id])
 
      if @user.blank?
        # not_authenticated
        return false
      else
        return true
      end
    end
end