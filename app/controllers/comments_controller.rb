class CommentsController < ApiBaseController
  before_action :set_comment, only: [:show, :update, :destroy]

  def index
    @comments = Comment.all
    if @comments.all
      render status: :ok, json: @comments
    else
      render status: :no_content, nothing: true
    end
  end

  def create
    comment = Note.find(params[:note_id]).comment.build(comment_params)
    if comment.save!
      render status: :ok, json: comment
    else
      render status: :bad_request, nothing: true
    end
  end

  def show
    if @comment
      render status: :ok, json: @comment
    else
      render status: :no_content, nothing: true
    end
  end

  def update
    if @comment.update(comment_params)
      render status: :ok, json: @comment
    else
      render status: :bad_request, nothing: true
    end
  end

  def destroy
    if @comment.destroy!
      render status: :ok, nothing: true
    else
      render status: :bad_request, nothing: true
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:contents, :user_id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
  # def note_params
  #   params.require(:note).permit(:title, :desc)
  # end

  # def set_note
  #   @note = Note.find(params[:id])
  # end
end