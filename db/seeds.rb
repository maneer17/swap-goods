# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
categories = [
  "Electronics", "Furniture", "Clothing", "Books", "Toys",
  "Sports", "Appliances", "Beauty", "Kitchen", "Garden",
  "Tools", "Vehicles", "Pets", "Collectibles", "Art",
  "Music", "Baby", "Accessories", "Health", "Office"
]

puts "Creating categories..."
categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
  puts "Created category: #{category_name}"
end
puts "Categories created successfully!"
# db/seeds.rb
puts "Cleaning up existing data..."
# Delete in reverse dependency order
Swap.destroy_all
ItemCategory.destroy_all
Item.destroy_all
User.destroy_all

puts "Creating users..."
users = [
  {
    username: "ahmed_tech",
    email_address: "ahmed@example.com",
    password: "password123",
    location: "gaza",
    verified: false
  },
  {
    username: "mohammed_books",
    email_address: "mohammed@example.com",
    password: "password123",
    location: "south",
    verified: false
  },
  {
    username: "sara_art",
    email_address: "sara@example.com",
    password: "password123",
    location: "midarea",
    verified: false
  },
  {
    username: "lina_design",
    email_address: "lina@example.com",
    password: "password123",
    location: "gaza",
    verified: false
  }
]

created_users = users.map do |user_data|
  User.create!(user_data)
end

ahmed, mohammed, sara, lina = created_users

puts "Creating items..."

# Get categories to assign to items
electronics = Category.find_by(name: "Electronics")
books = Category.find_by(name: "Books")
art = Category.find_by(name: "Art")
clothing = Category.find_by(name: "Clothing")
kitchen = Category.find_by(name: "Kitchen")
sports = Category.find_by(name: "Sports")
toys = Category.find_by(name: "Toys")
accessories = Category.find_by(name: "Accessories")

items = [
  # Ahmed's items (Gaza)
  {
    user: ahmed,
    name: "iPhone 12",
    description: "Good condition, 128GB, comes with original charger",
    status: :available,
    categories: [ electronics ]
  },
  {
    user: ahmed,
    name: "Wireless Headphones",
    description: "Brand new, never used, great sound quality",
    status: :available,
    categories: [ electronics, accessories ]
  },

  # Mohammed's items (South)
  {
    user: mohammed,
    name: "The Alchemist",
    description: "Paperback edition, like new condition",
    status: :available,
    categories: [ books ]
  },
  {
    user: mohammed,
    name: "Basketball",
    description: "Professional size, good for outdoor courts",
    status: :available,
    categories: [ sports ]
  },

  # Sara's items (Midarea)
  {
    user: sara,
    name: "Handmade Painting",
    description: "Original artwork, acrylic on canvas, 30x40cm",
    status: :available,
    categories: [ art ]
  },
  {
    user: sara,
    name: "Designer Jacket",
    description: "Size M, worn only a few times, excellent condition",
    status: :available,
    categories: [ clothing ]
  },

  # Lina's items (Gaza)
  {
    user: lina,
    name: "Coffee Maker",
    description: "Works perfectly, includes coffee filters",
    status: :available,
    categories: [ kitchen, clothing ]
  },
  {
    user: lina,
    name: "Board Game Collection",
    description: "3 popular board games in great condition",
    status: :available,
    categories: [ toys ]
  }
]

created_items = items.map do |item_data|
  categories = item_data.delete(:categories)
  item = Item.create!(item_data)
  item.categories << categories if categories
  item
end

# Assign items to variables for easier reference
iphone, headphones, alchemist, basketball, painting, jacket, coffee_maker, board_games = created_items

puts "Creating swaps..."

# Create some realistic swap scenarios
swaps = [
  # Pending swap: Ahmed wants Mohammed's book for his headphones
  {
    requester_item: headphones,
    receiver_item: alchemist,
    status: "pending"
  },
  # Accepted swap: Sara's painting for Lina's board games
  {
    requester_item: painting,
    receiver_item: board_games,
    status: "accepted"
  },
  # Another pending swap: Mohammed wants Ahmed's iPhone for his basketball
  {
    requester_item: basketball,
    receiver_item: iphone,
    status: "pending"
  }
]

swaps.each do |swap_data|
  Swap.create!(swap_data)
end

# Update item statuses based on swaps
headphones.update(status: :pending)  # Pending in swap
painting.update(status: :swapped)    # Accepted swap
board_games.update(status: :swapped) # Accepted swap

puts "Seed data created successfully!"
puts "---"
puts "Created #{User.count} users"
puts "Created #{Item.count} items"
puts "Created #{Swap.count} swaps"
puts "---"
puts "Sample data:"
puts "- Ahmed (Gaza) has: iPhone 12, Wireless Headphones"
puts "- Mohammed (South) has: The Alchemist, Basketball"
puts "- Sara (Midarea) has: Handmade Painting, Designer Jacket"
puts "- Lina (Gaza) has: Coffee Maker, Board Game Collection"
puts "---"
puts "Active swaps:"
puts "- Ahmed offered Headphones for Mohammed's Alchemist (pending)"
puts "- Sara traded Painting for Lina's Board Games (accepted)"
puts "- Mohammed offered Basketball for Ahmed's iPhone (pending)"
