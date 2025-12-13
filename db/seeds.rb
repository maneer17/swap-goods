

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
