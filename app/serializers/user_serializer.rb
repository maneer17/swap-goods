class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email_address, :username, :location, :verified
end
