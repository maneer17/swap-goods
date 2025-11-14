module Authentication
  class ForgetPasswordService
    def self.call(email_address)
      user = User.find_by(email_address: email_address)
      if user
        send_reset_password_email(user)
        { success: true, message: "Password reset link has been sent to your email. Token will expire in 1 hour." }
      else
        { success: false, error: "No account found with this email address." }
      end
    end
      private
      def self.send_reset_password_email(user)
        token = user.generate_token_for(:reset_password)
        UserMailer.reset_password(token: token, user: user).deliver_later
    end
  end
end
