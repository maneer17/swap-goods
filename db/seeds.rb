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
