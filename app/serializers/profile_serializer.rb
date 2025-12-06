class ProfileSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :avatar
  attribute :avatar do |item|
    if item.avatar.attached
      Rails.application.routes.url_helpers.url_for(item.avatar)
    else
      nil
    end
  end

  attribute :incoming_requests do |item|
    item.user.incoming_swap_requests
  end
  attribute :outgoing_requests do |item|
    item.user.outgoing_swap_requests
  end
end
