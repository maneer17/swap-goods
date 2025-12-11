class Api::V1::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :update]
  
  # POST /api/v1/profiles
  def create
    # Check if profile already exists
    if @current_user.profile.present?
      return render json: { error: 'Profile already exists' }, status: :conflict
    end
    
    profile = @current_user.build_profile(profile_params)
    
    # The avatar will be attached automatically via ActiveStorage
    if profile.save
      render json: ProfileSerializer.new(profile, { 
        params: { owner: true } 
      }), status: :created
    else
      render json: { 
        errors: profile.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/profiles/:user_id
  def show
    is_owner = @current_user.id == @profile.user_id
    
    render json: ProfileSerializer.new(@profile, { 
      params: { owner: is_owner } 
    })
  end
  
  # PATCH /api/v1/profiles/:user_id
  def update
    if @current_user.id != @profile.user_id
      return render json: { error: 'Not authorized' }, status: :forbidden
    end
    
    if @profile.update(profile_params)
      @profile.avatar.attach(profile_params[:avatar])
      render json: ProfileSerializer.new(@profile, { 
        params: { owner: true } 
      })
    else
      render json: { 
        errors: @profile.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_profile
    @profile = Profile.find_by!(user_id: params[:user_id])
  end
  
  def profile_params
    # Permit avatar as a file upload
    params.require(:profile).permit(:description, :avatar)
  end
  
  def authenticate_user!
    # Make sure @current_user is set
    return if @current_user
    
    render json: { error: 'Not authenticated' }, status: :unauthorized
  end
end