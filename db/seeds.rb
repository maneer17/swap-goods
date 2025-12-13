# db/seeds.rb
require "faker"

puts "🌱 Clearing database..."

Swap.destroy_all
ItemCategory.destroy_all
Item.destroy_all
Profile.destroy_all
User.destroy_all
Category.destroy_all

puts "🌱 Creating categories..."

categories = [
  "Electronics", "Furniture", "Clothing", "Books", "Toys",
  "Sports", "Appliances", "Beauty", "Kitchen", "Garden",
  "Tools", "Vehicles", "Pets", "Collectibles", "Art",
  "Music", "Baby", "Accessories", "Health", "Office"
]

category_records = categories.map do |name|
  Category.create!(name: name)
end

puts "✅ #{Category.count} categories created"

# -------------------------
# USERS + PROFILES
# -------------------------
puts "🌱 Creating users..."

locations = User.locations.keys

users = 10.times.map do
  username = Faker::Internet.unique.username(specifier: 5..10)

  user = User.create!(
    username: username,
    email_address: Faker::Internet.unique.email,
    password: "password123",
    password_confirmation: "password123",
    location: locations.sample,
    verified: Faker::Boolean.boolean
  )

  Profile.create!(
    user: user,
    description: Faker::Lorem.paragraph(sentence_count: 3)
  )

  user
end

puts "✅ #{User.count} users created"

# -------------------------
# ITEMS
# -------------------------
puts "🌱 Creating items..."

items = []

users.each do |user|
  rand(2..4).times do
    item = Item.create!(
      user: user,
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.sentence(word_count: 12),
      status: :available
    )

    # Assign 1–3 categories
    item.categories << category_records.sample(rand(1..3))

    items << item
  end
end

puts "✅ #{Item.count} items created"

# -------------------------
# SWAPS
# -------------------------
puts "🌱 Creating swaps..."

available_items = Item.available.to_a

20.times do
  requester_item = available_items.sample
  receiver_item = available_items.sample

  # Skip invalid swaps
  next if requester_item.nil? || receiver_item.nil?
  next if requester_item.user_id == receiver_item.user_id
  next if requester_item.id == receiver_item.id

  Swap.create!(
    requester_item: requester_item,
    receiver_item: receiver_item,
    status: %w[pending accepted rejected].sample,
    reason: Faker::Lorem.sentence
  )
end

puts "✅ #{Swap.count} swaps created"

puts "🌱 Seeding completed successfully!"
