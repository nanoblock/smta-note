class CommentsController < ApiBaseController
  before_action :error_user_param, :error_note_param
  
  before_action :set_note

  def index
    @comments = @note.comment

    if @comments
      render 'jbuilder/comment_array', status: :ok, formats: 'json'
    else
      render error_not_found
    end

  end

  def create
    @comment = @note.comment.build(comment_params)
    if @comment.save!
      render 'jbuilder/comment', status: :ok, formats: 'json'
    else
      return error_not_found
    end
  end

  def show
    if set_comment
      render 'jbuilder/comment', status: :ok, formats: 'json'
    else
      return error_not_found
    end
  end

  def update
    if set_comment.update(comment_params)
      render 'jbuilder/comment', status: :ok, formats: 'json'
    else
      return error_not_found
    end
  end

  def destroy
    if set_comment.destroy!
      render status: :ok, nothing: true
    else
      return error_not_found
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:contents)
  end

  def set_note
    @note = current_user.notes.find_by_id(params[:note_id])
  end

  def set_comment
    @comment = @note.comment.find_by_id(params[:id])
  end

  def exsist_note
    return error_not_found if !current_user.notes.exists?(id: params[:note_id])
  end

end