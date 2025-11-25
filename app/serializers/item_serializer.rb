class ItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :status, :categories
end
