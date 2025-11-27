class Item < ApplicationRecord
  belongs_to :user
  delegate :location, to: :user
  enum :status, { available: 0, pending: 1, unavailable: 2, swapped: 3 }
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
      "name ILIKE :q OR description ILIKE :q",
      q: "%#{query}%"
    )
  end
end
