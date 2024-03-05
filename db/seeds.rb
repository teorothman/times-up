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

avatar_monkey = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_bear = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_giraffe = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_gorila = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_chicken = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_lion = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_sheep = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_tiger = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_owl = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_polar = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_lea = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_simba = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_fox = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_monkey2 = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")
avatar_gorila2 = URI.open("https://collection.cloudinary.com/doind6rcn/3f635ee4be0880db3032447dfa9e27c0")

avatar_arr = [avatar_monkey, avatar_bear, avatar_giraffe, avatar_gorila, avatar_chicken, avatar_lion, avatar_sheep, avatar_tiger, avatar_owl, avatar_polar, avatar_lea, avatar_simba, avatar_fox, avatar_monkey2, avatar_gorila2]


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
