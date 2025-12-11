class ProfileSerializer
  include JSONAPI::Serializer

  attributes :id, :user_id, :description

  attribute :avatar do |profile|
    profile.avatar.attached? ? Rails.application.routes.url_helpers.url_for(profile.avatar) : nil
  end

  attribute :incoming_swaps, if: proc { |_profile, params|
    params && params[:owner]
  } do |profile|
    profile.user.incoming_swap_requests
  end

  attribute :outgoing_swaps, if: proc { |_profile, params|
    params && params[:owner]
  } do |profile|
    profile.user.outgoing_swap_requests
  end
end
