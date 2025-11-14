module Authentication
  class LoginService
    def self.call(username, password)
      user = User.find_by!(username: username)
      if user&.authenticate(password)
        access_token = JsonWebToken.generate_token(user_id: user.id)
        {
          success: true,
          message: "User logged in successfully. Token will expire in 24 hours.",
          user: UserSerializer.new(user).serializable_hash[:data][:attributes],
          access_token: access_token
        }
      else
        { success: false, error: "Invalid credentials" }
      end
    end
  end
end
