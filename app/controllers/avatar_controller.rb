class AvatarController < ApiBaseController
  before_action :set_token, only: [:upload]

  skip_before_action :require_valid_token, :only => [:upload]

  def upload
    bucket_exsist? S3_BUCKET

    begin
      @incoming_file = params[:image]
      @file_name = params[:image].original_filename

      # FileUtils.mv @incoming_file.tempfile, path(@file_name)

      S3_BUCKET.put_object(
          body: File.open(@incoming_file.tempfile),
          key: avatar_bucket + @file_name,
          acl: 'public-read')
      
      File.delete(path(@incoming_file.tempfile) if File.exist?(@incoming_file.tempfile)
    rescue Exception => e
      s3_upload_fail e
    end
  
    user = User.find(@token.user_id)
    user.avatar_url = avatar_bucket + @file_name

    if user.save!
      render status: :ok, json: @user 
    else
      render status: :bad_request, nothing: true
    end

  end

  private
  def set_token
    @token = Token.find_by_access_token(@access_token)
  end

  def s3_path
    return "https://s3.ap-northeast-2.amazonaws.com/smta-note/"
  end

  def avatar_bucket
    return  "media/image/avatar/" + @token.user_id + "/"
  end

end