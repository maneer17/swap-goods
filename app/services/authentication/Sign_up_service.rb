module Authentication
  class SignUpService
    def self.call(user_params)
      user = User.new(user_params)
      if user.save
        send_confirmation_email(user)
          { success: true, message: "Confirmation email sent, token will expire in 2 days" }
      else
        { success: false, errors: user.errors.full_messages }
      end
    end

    private
    def self.send_confirmation_email(user)
      token = user.generate_token_for(:user_confirmation)
      UserMailer.confirm_email(token: token, user: user).deliver_now
    end
  end
end
