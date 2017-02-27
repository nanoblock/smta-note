class ApiBaseController < ApplicationController
  include ApplicationHelper

  before_action :invalid_exsist_token, :require_valid_token
  skip_before_action :invalid_exsist_token, only: [:search_note, :test]
  skip_before_action :require_valid_token, only: [:search_note, :test]

  def search
    @note = Note.search(:title_or_desc_cont => params[:q]).result
    @note = paginate @note
    if !@note.empty?
      return render 'jbuilder/note_array', status: :ok, formats: 'json'
    else
      return error_not_found
    end
  end

  def search_note

    if params[:reset].to_s
      @note = Note.search(:title_or_desc_cont => params[:q]).result
    else
      @note ||= Note.search(:title_or_desc_cont => params[:q]).result
    end

    @note = paginate @note
    render 'jbuilder/note_array', status: :ok, formats: 'json'
  end

  def error_format(code, message)
    return render status: code, json: error_format_json(code, message)
  end

  def error_format_json(code, message)
    json = {
      "code": code,
      "status": Rack::Utils::HTTP_STATUS_CODES[code],
      "message": message
    }
    return json.to_json
  end

  private

  def require_valid_token
    return render status: :unauthorized, json: error_format(401, Rack::Utils::HTTP_STATUS_CODES[401], "Invalid token") if invalid_token @access_token
    # return render status: :unauthorized, json: error_format(401, Rack::Utils::HTTP_STATUS_CODES[401], "User do not login") if invalid_lagin @access_token
  end

  def invalid_exsist_token
    @access_token = request.headers[:HTTP_ACCESS_TOKEN]

    if !@access_token
      return render status: :bad_request, noting: true 
    else
      return @access_token
    end
  end

  def invalid_token(token)
    return true if Token.find_by_access_token(token).nil?
  end

  def invalid_lagin(token)
    return true if !User.login?(token)
  end

  def error_not_found
    error_format(204, "No Content")
  end

  def error_user_param(user_id = params[:user_id].to_i)
    @token = Token.find_by_access_token(@access_token)
    @user = User.find(@token.user_id)
    unless @user.id.to_i == user_id.to_i
      error_format(400, "Parameter does not match user data") 
    end
  end

  def error_note_param(note_id = params[:note_id].to_i)
    @token = Token.find_by_access_token(@access_token)
    @user = User.find(@token.user_id)

    unless @user.notes.exists?(id: params[:note_id])
      error_format(400, "Parameter does not match note date")
    end
  end

end