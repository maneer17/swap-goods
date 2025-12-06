class Item < ApplicationRecord
  belongs_to :user
  delegate :location, to: :user
  enum :status, { available: 0, pending: 1, unavailable: 2 }
  has_many :item_categories, dependent: :destroy
  has_many :categories, through: :item_categories
  has_many_attached :images
  has_many :requested_swaps, class_name: "Swap", foreign_key: :requester_item_id
  has_many :received_swaps, class_name: "Swap", foreign_key: :receiver_item_id


  scope :by_category, ->(category_ids) {
    joins(:categories).where(categories: { id: category_ids }).distinct
  }
  scope :by_locations, ->(locations) {
    joins(:user).where(users: { location: locations })
  }
  scope :by_status, ->(status) { where(status: status) }
  def self.search(query)
    where(
      "items.name ILIKE :q OR items.description ILIKE :q",  # ✅ Specify items.name
      q: "%#{query}%"
    )
  end

  def incoming_swaps
    received_swaps.all
  end
  def outgoing_swaps
    requested_swaps.all
  end
  def cancel_outgoing_swaps
    # Cancel all swaps where this item is requesting other items
    requested_swaps.pending.destroy_all
  end

  def cancel_incoming_swaps
    received_swaps.pending.destroy_all
  end

  def make_item_unavailable
    Item.transaction do
      cancel_incoming_swaps
      cancel_outgoing_swaps
      update!(status: :unavailable)
    end
  end
end
