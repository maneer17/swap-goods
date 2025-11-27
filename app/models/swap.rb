class Swap < ApplicationRecord
  belongs_to :requester_item, class_name: "Item"
  belongs_to :receiver_item, class_name: "Item"
  enum :status, { pending: "pending", accepted: "accepted", rejected: "rejected", cancelled: "cancelled" }
  validate :items_belong_to_different_users
  validate :items_are_available

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
