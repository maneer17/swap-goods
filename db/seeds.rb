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

puts "Creating additional swaps..."

# Swap 4:
# Lina (Yoga Mat) ⇆ Sara (Leather Jacket)
Swap.create!(
  requester_item: board_games,
  receiver_item: leather_jacket,
  status: :pending
)

# Swap 5:
# Ahmed (iPhone 12) ⇆ Lina (Coffee Maker)
Swap.create!(
  requester_item: iphone,
  receiver_item: coffee_maker,
  status: :accepted
)

# Swap 6:
# Mohammed (The Alchemist) ⇆ Sara (Painting)
Swap.create!(
  requester_item: alchemist,
  receiver_item: painting,
  status: :pending
)

# Swap 7:
# Sara (Leather Jacket) ⇆ Mohammed (Basketball)
Swap.create!(
  requester_item: leather_jacket,
  receiver_item: basketball,
  status: :rejected
)

# Swap 8:
# Ahmed (Wireless Headphones) ⇆ Lina (Yoga Mat)
Swap.create!(
  requester_item: headphones,
  receiver_item: board_games,
  status: :pending
)

# Swap 9:
# Mohammed (Basketball) ⇆ Sara (Leather Jacket)
Swap.create!(
  requester_item: basketball,
  receiver_item: leather_jacket,
  status: :accepted
)

# Swap 10:
# Lina (Coffee Maker) ⇆ Ahmed (Wireless Headphones)
Swap.create!(
  requester_item: coffee_maker,
  receiver_item: headphones,
  status: :pending
)

# Swap 11:
# Sara (Painting) ⇆ Ahmed (iPhone 12)
Swap.create!(
  requester_item: painting,
  receiver_item: iphone,
  status: :cancelled
)

# Swap 12:
# Mohammed (The Alchemist) ⇆ Ahmed (Wireless Headphones)
Swap.create!(
  requester_item: alchemist,
  receiver_item: headphones,
  status: :pending
)

# Swap 13:
# Ahmed (Wireless Headphones) ⇆ Mohammed (The Alchemist)
Swap.create!(
  requester_item: headphones,
  receiver_item: alchemist,
  status: :accepted
)

# Swap 14:
# Lina (Yoga Mat) ⇆ Mohammed (Basketball)
Swap.create!(
  requester_item: board_games,
  receiver_item: basketball,
  status: :pending
)

# Swap 15:
# Sara (Painting) ⇆ Lina (Yoga Mat)
Swap.create!(
  requester_item: painting,
  receiver_item: board_games,
  status: :completed
)

puts "Additional swaps created!"
