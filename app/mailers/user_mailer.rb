class UserMailer < ApplicationMailer
  def confirm_email(token:, user:)
    @confirmation_url  = "https://your-frontend-app.com/verify-email?token=#{token}"
    @user = user
    mail(to: @user.email_address, subject: "Cofirm Your Email")
  end
  def reset_password(token:, user:)
    @reset_url = "https://your-frontend-app.com/forget-password?token=#{token}"
    @user = user
    mail(to: @user.email_address, subject: "Reset Your Password")
  end
end
