module Authentication
  class ResetPasswordService
    def self.call(token, password, password_confirmation)
      user = User.find_by_token_for(:reset_password, token)
      return { success: false, error: "Invalid or expired token." } unless user
      if user.update(password: password, password_confirmation: password_confirmation)
        { success: true, message: "Password has been reset successfully." }
      else
        { success: false, errors: user.errors.full_messages }
      end
    end
  end
end
