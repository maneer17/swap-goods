module Authentication
  class EmailVerificationService
    def self.call(token)
      user = User.find_by_token_for(:user_confirmation, token)

      unless user
        return { success: false, error: "Invalid or expired token." }
      end

      access_token = JsonWebToken.generate_token(user_id: user.id)

      if user.verified?
        {
          success: true,
          message: "Account already verified.",
          access_token: access_token,
          user: UserSerializer.new(user).serializable_hash[:data][:attributes]
        }
      else
        user.update!(verified: true)
        {
          success: true,
          message: "Email successfully verified!",
          access_token: access_token,
          user: UserSerializer.new(user).serializable_hash[:data][:attributes]
        }
      end
    end
  end
end
