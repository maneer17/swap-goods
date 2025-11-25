class Category < ApplicationRecord
  has_many :item_categories
  has_many :items, through: :item_categories
  enum :category, {
  electronics: "electronics",
  furniture: "furniture",
  clothing: "clothing",
  books: "books",
  toys: "toys",
  sports: "sports",
  appliances: "appliances",
  beauty: "beauty",
  kitchen: "kitchen",
  garden: "garden",
  tools: "tools",
  vehicles: "vehicles",
  pets: "pets",
  collectibles: "collectibles",
  art: "art",
  music: "music",
  baby: "baby",
  accessories: "accessories",
  health: "health",
  office: "office"
}
end
