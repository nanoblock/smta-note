class Mailer < ApplicationMailer
  default from: "atsmucha@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.activation_user_email.subject
  #
  def activation_needed_email(user)
    @user = user
    @url = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"

    mail to: @user.email, subject: "[적어적어]마! 이메일 인증해라"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.activation_success_email.subject
  #

  def congratulation_email(user)
    @user = user
    mail to: @user.email, subject: "[IDEANOTE] 환영합니다."
  end

  def activation_success_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/login"

    mail to: user.email, subject: "[환영]마! 환영한다"
  end

  def reset_password_email(user)
    @user = User.find user.id
    @url = "http://0.0.0.0:3000" + password_reset_path(@user.reset_password_token)
    mail(:to => user.email,  :subject => "Your password has been reset")
    
  end
end
