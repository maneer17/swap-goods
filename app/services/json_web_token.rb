require "jwt"
class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base
  ALGORITHM = "HS256"
  def self.generate_token(payload, exp = Time.now.to_i + 3600 * 24)
    payload[:exp]= exp
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode_token(token)
    body = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
    HashWithIndifferentAccess.new body[0]
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
      nil
  end
end
