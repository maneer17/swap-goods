class ItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :status, :location, :user_id
  attribute :categories do |item|
    item.categories.map { |c| c.name }
  end
  attribute :image_urls do |item|
    item.images.map { |img| Rails.application.routes.url_helpers.url_for(img) }
  end
end
