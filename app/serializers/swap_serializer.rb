class SwapSerializer
  include JSONAPI::Serializer
  attributes :id, :status
  attribute :requester_item do |swap|
    ItemSerializer.new(swap.requester_item).serializable_hash
  end
  attribute :receiver_item do |swap|
    ItemSerializer.new(swap.receiver_item).serializable_hash
  end
end 