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

avatar_monkey = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-14_ikiqvl.png")
avatar_bear = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-02_twwxaq.png")
avatar_giraffe = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-16_h4vizy.png")
avatar_gorila = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-06_wbxnuw.png")
avatar_chicken = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-05_zvchxj.png")
avatar_lion = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-10_ibpn86.png")
avatar_sheep = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-15_koyuzp.png")
avatar_tiger = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-11_eqll2c.png")
avatar_owl = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-08_ex0kbv.png")
avatar_polar = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-04_lofhb4.png")
avatar_lea = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-09_jwxyv4.png")
avatar_simba = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-12_t8w7vy.png")
avatar_fox = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-13_nvdl5t.png")
avatar_monkey2 = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-01_adfxjf.png")
avatar_gorila2 = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-03_mx9203.png")
avatar_cat = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-07_fl3xsc.png")

avatar_arr = [avatar_monkey, avatar_bear, avatar_giraffe, avatar_gorila, avatar_chicken, avatar_lion, avatar_sheep, avatar_tiger, avatar_owl, avatar_polar, avatar_lea, avatar_simba, avatar_fox, avatar_monkey2, avatar_gorila2, avatar_cat]

# Game.new to nest users

  4.times do
    # avatar = select random img from avatar range

    avatar = avatar_arr.sample

    username = Faker::Name.unique.first_name.downcase
    user = User.new(username: username, game_id: game.id)
    user.photo.attach(io: avatar, filename: "#{username}.png", content_type: "image/png")

    # 5.times do
    #   Card.new will come here
    # end
  end
