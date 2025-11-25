class Item < ApplicationRecord
  belongs_to :user
  enum :status, { available: 0, pending: 1, unavailable: 2, swapped: 3 }
  has_many :item_categories
  has_many :categories, through: :item_categories
  has_many_attached :images
end
