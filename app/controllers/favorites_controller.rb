class FavoritesController < ApiBaseController
  before_action :error_user_param, :error_note_param
  before_action :set_favorite, only: [:show, :destroy]

  def index
    @favorites = current_note.favorites.order("updated_at DESC")
    if @favorites
      render 'jbuilder/favorite_array', status: :ok, formats: 'json'
    else
      return error_not_found
    end
  end

  def create
    @favorite = current_note.favorites.build(favorite_params)
    if @favorite.save!
      render 'jbuilder/favorite', status: :ok, formats: 'json'
    else
      error_render @favorite.errors
    end
  end

  def show
    if @favorite
      render 'jbuilder/favorite', status: :ok, formats: 'json'
    else
      return error_not_found
    end
  end

  def destroy
    if @favorite.destroy!
      render status: :ok, nothing: true
    else
      return error_not_found
    end
  end

  private 

  def favorite_params
    params.require(:favorite).permit(:user_id)
  end

  def current_note(id = params[:note_id].to_i)
    @user.notes.find(id)
  end

  def set_favorite(id = params[:id].to_i)
    begin
      @favorite = current_note.favorites.find(id)
    rescue Exception => e
      error_favorite_param
    end
    @favorite
  end

  def error_favorite_param(favorite_id = params[:favorite_id])
    unless @user.notes.find(params[:note_id]).favorites.exists?(id: favorite_id)
      error_format(400, "Parameter does not match favorite date")
    end
  end

  def error_render(error)
    error_format(400, "#{error}")
  end

end