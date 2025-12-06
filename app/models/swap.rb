class Swap < ApplicationRecord
  belongs_to :requester_item, class_name: "Item"
  belongs_to :receiver_item, class_name: "Item"
  enum :status, { pending: "pending", accepted: "accepted", rejected: "rejected" }, validate: true
  validate :items_belong_to_different_users, on: :create
  validate :items_are_available, on: [ :create, :transfer_ownership ]


  def transfer_ownership
    Swap.transaction do
      temp = receiver_item.user
      receiver_item.update!(user: requester_item.user, swaps_count: receiver_item.swaps_count + 1)
      requester_item.update!(user: temp, swaps_count: requester_item.swaps_count+ 1)
      receiver_item.cancel_outgoing_swaps
      requester_item.cancel_outgoing_swaps
    end
  end



  private
  def items_belong_to_different_users
    if requester_item.user_id == receiver_item.user_id
      errors.add(:base, "You can't make a swap with yourself! ")
    end
  end
  def items_are_available
    unless requester_item.available? && receiver_item.available?
      errors.add(:base, "Both items must be available to swap.")
    end
  end
end
