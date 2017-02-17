class NotesController < ApiBaseController
  before_action :set_note, only: [:show, :update, :destroy]

  def index
    @notes = Note.all

    if @notes
      render status: :ok, json: @notes
    else
      render status: :no_content, nothing: true
    end
  end

  def create
    note = current_user.notes.build(note_params)
    if note.save!
      render status: :ok, json: note
    else
      render status: :bad_request, nothing: true
    end
  end

  def show
    if @note
      render status: :ok, json: @note
    else
      render status: :no_content, nothing: true
    end
  end

  def update
    if @note.update(note_params)
      render status: :ok, json: @note
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