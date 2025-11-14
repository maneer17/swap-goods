class ApplicationController < ActionController::API
  before_action :authenticate_user
  rescue_from ActiveRecord::RecordNotFound, with: :handle_user_not_found

  private
  def authenticate_user
    auth_header = request.headers["Authorization"]
    unless auth_header&.start_with?("Bearer ")
      return render json: { error: "Missing or invalid authorization header" }, status: :unauthorized
    end

    token = auth_header.split(" ").last

    unless token.present?
      return render json: { error: "Missing token" }, status: :unauthorized
    end

    # Let exceptions bubble up to rescue_from
    payload = JsonWebToken.decode_token(token)
    return render json: { error: "Invalid or expired token" }, status: :unauthorized unless payload
    @current_user = User.find_by(id: payload["user_id"])
    unless @current_user
      render json: { error: "User not found" }, status: :unauthorized
    end
  end

  def handle_expired_token(exception)
    render json: { error: "Token has expired. Please log in again." }, status: :unauthorized
  end

  def handle_invalid_token(exception)
    render json: { error: "Invalid token" }, status: :unauthorized
  end

  def handle_user_not_found(exception)
    render json: { error: "User not found" }, status: :unauthorized
  end
end
