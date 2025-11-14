module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user, except: :me
      rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
      rescue_from ActionController::ParameterMissing, with: :handle_missing_params

      def sign_up
        result = Authentication::SignUpService.call(user_params)
        render_result(result, success_status: :created)
      end

      def verify_email
        token = params[:token]
        result = Authentication::EmailVerificationService.call(token)
        render_result(result)
      end

      # POST /api/v1/auth/login
      def login
        result = Authentication::LoginService.call(login_params[:username], login_params[:password])
        render_result(result, failed_status: :unauthorized)
      end

      # GET /api/v1/auth/me
      def me
        render json: {
          user: UserSerializer.new(@current_user).serializable_hash[:data][:attributes]
        }, status: :ok
      end

      # POST /api/v1/auth/forget_password
      def forget_password
        result = Authentication::ForgetPasswordService.call(forget_password_params[:email_address])
        render_result(result, failed_status: :not_found)
      end

      # POST /api/v1/auth/reset_password
      def reset_password
        result = Authentication::ResetPasswordService.call(reset_password_params[:token],
        reset_password_params[:password], reset_password_params[:password_confirmation])
        render_result(result)
      end

      private

      def render_result(result, success_status: :ok, failed_status: :unprocessable_entity)
         if result[:success]
          render json: result, status: success_status
         else
          render json: result, status: failed_status
         end
      end

      def user_params
        params.require(:user).permit(:email_address, :password, :password_confirmation, :username, :location)
      end

      def login_params
        params.require(:user).permit(:username, :password)
      end

      def forget_password_params
        params.require(:forget_password_params).permit(:email_address)
      end

      def reset_password_params
        params.require(:reset_password_params).permit(:token, :password, :password_confirmation)
      end

      # Handle missing records gracefully
      def handle_record_not_found(_error)
        render json: { message: "User not found." }, status: :not_found
      end
      def handle_missing_params(_error)
        render json: { error: _error.message }, status: :unprocessable_entity
      end
    end
  end
end
