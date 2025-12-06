class Api::V1::ProfilesController < ApplicationController
  before_action :profile_params, only: :create
  before_action :set_profile, only: :show
  def create
    profile = Profile.new(profile_params.merge(user: @current_user))
    profile.avatar.attach(profile_params[:avatar])
    if profile.save
      render json: { message: "profile has been created successfully" }, status: :created
    else
      render json: { success: false, errors: profile.errors.full_messages }
    end
  end

  def show
    if @profile
      render json: ProfileSerializer.new(@profile).serializable_hash
    else
      render json: @profile.errors.full_messages
    end
  end

  def update
  end



  private
  def set_profile
    @profile = @current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:avatar)
  end
end
