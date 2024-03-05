# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Dropping DB..."

# Game.destroy_all
User.destroy_all
# Card.destroy_all

puts "Loading avatars..."
avatar_arr = []

# Game.new to nest users
4.times do
  # avatar = select random img from avatar range

  avatar = avatar_arr.sample

  username = Faker::Name.unique.firstname
  user = User.new(username: username)
  user.photo.attach(io: avatar, filename: "#{username}.png", content_type: "image/png")

  # 5.times do
  #   Card.new will come here
  # end
end
