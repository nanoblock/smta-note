class NotesController < ApiBaseController
  before_action :error_user_param
  before_action :set_note, only: [:show, :update, :destroy]

  def index
    @note = Note.all

    if @note
      render 'jbuilder/note_array', status: :ok, formats: 'json'
      # render status: :ok, json: @note
    else
      render status: :no_content, nothing: true
    end
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save!
      render 'jbuilder/note', status: :ok, formats: 'json'
    else
      render status: :bad_request, nothing: true
    end
  end

  def show
    if @note
      render 'jbuilder/note', status: :ok, formats: 'json'
    else
      render status: :no_content, nothing: true
    end
  end

  def update
    if @note.update(note_params)
      render 'jbuilder/note', status: :ok, formats: 'json'
    else
      render status: :bad_request, nothing: true
    end
  end

  def destroy
    if @note.destroy!
      render status: :ok, nothing: true 
    else
      render status: :bad_request, nothing: true
    end
  end

  private
  def note_params
    params.require(:note).permit(:title, :desc)
  end

  def set_note
    @note = Note.find(params[:id])
  end

end