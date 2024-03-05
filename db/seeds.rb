puts "Dropping current data"
Turn.destroy_all
Card.destroy_all
User.destroy_all
Round.destroy_all
Team.destroy_all
Game.destroy_all


puts "Creating 1 game"
Game.create! code: 123456, url: "https://www.instagram.com/p/y-al3LtwsQ/", is_default: true

puts "Creating 2 teams"
Team.create! name: 1
Team.create! name: 2

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


puts "Creating 1 creator for team 1..."

user = User.new(
  username: Faker::Name.first_name,
  game_id: Game.first.id,
  is_creator: true,
  team_id: Team.find_by(name: 1).id,
  points_round_1: 0,
  points_round_2: 0,
  points_round_3: 0
)
avatar = avatar_arr.sample
user.photo.attach(io: File.open(avatar), filename: "#{user.username}.png", content_type: "image/png")
user.save

puts "Creating 3 joiners for team 1..."
3.times do
  # avatar = select random img from avatar range
  user = User.new(
    username: Faker::Name.first_name,
    game_id: Game.first.id,
    is_creator: false,
    team_id: Team.find_by(name: 1).id,
    points_round_1: 0,
    points_round_2: 0,
    points_round_3: 0
  )
  avatar = avatar_arr.sample
  user.photo.attach(io: File.open(avatar), filename: "#{user.username}.png", content_type: "image/png")
  user.save
end

puts "Creating 4 joiners for team 2..."
4.times do
  # avatar = select random img from avatar range
  user = User.new(
    username: Faker::Name.first_name,
    game_id: Game.first.id,
    is_creator: false,
    team_id: Team.find_by(name: 2).id,
    points_round_1: 0,
    points_round_2: 0,
    points_round_3: 0
  )
  avatar = avatar_arr.sample
  user.photo.attach(io: File.open(avatar), filename: "#{user.username}.png", content_type: "image/png")
  user.save
end

# 5.times do
#   Card.new will come here
# end
puts "Creating 40 cards"
times_up_guess_list = [
  "The Mona Lisa",
  "Eiffel Tower",
  "Shrek",
  "Cleopatra",
  "The Beatles",
  "Harry Potter",
  "Mount Everest",
  "Albert Einstein",
  "The Sphinx",
  "Leonardo da Vinci",
  "Marilyn Monroe",
  "Titanic",
  "Pikachu",
  "Statue of Liberty",
  "Michael Jackson",
  "Sherlock Holmes",
  "The Colosseum",
  "Elvis Presley",
  "Star Wars",
  "Napoleon Bonaparte",
  "Spider-Man",
  "The Hobbit",
  "Big Ben",
  "Vincent van Gogh",
  "Queen Elizabeth II",
  "The Godfather",
  "Machu Picchu",
  "Julius Caesar",
  "Batman",
  "Stonehenge",
  "William Shakespeare",
  "Frida Kahlo",
  "Jurassic Park",
  "King Arthur",
  "Charlie Chaplin",
  "James Bond",
  "The Grand Canyon",
  "Mozart",
  "The Wizard of Oz",
  "Steve Jobs",
]

times_up_guess_list.each do |word|
  card = Card.new(
    content: word,
    user_id: User.first.id,
    is_guessed: false,
    is_skipped: false
  )
  card.save
end


# puts "Dropping current data"
# Game.destroy_all
# Team.destroy_all
# User.destroy_all
# Card.destroy_all
# Round.destroy_all
# Turn.destroy_all
# Avatar.destroy_all


# puts "Creating 1 game"
# Game.create! code: 123456, url: "https://www.instagram.com/p/y-al3LtwsQ/", is_default: true

# puts "Creating 2 teams"
# Team.create! name: 1
# Team.create! name: 2

# puts "Creating avatars..."

# avatar = Avatar.new
# avatar.photo.attach(io: File.open("images/times up _ avatar -01.png"), filename: "avatar1.png", content_type: "image/png")
# avatar.save!

# avatar_monkey = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-14_ikiqvl.png")
# avatar_bear = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-02_twwxaq.png")
# avatar_giraffe = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-16_h4vizy.png")
# avatar_gorila = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-06_wbxnuw.png")
# avatar_chicken = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-05_zvchxj.png")
# avatar_lion = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-10_ibpn86.png")
# avatar_sheep = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-15_koyuzp.png")
# avatar_tiger = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-11_eqll2c.png")
# avatar_owl = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-08_ex0kbv.png")
# avatar_polar = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-04_lofhb4.png")
# avatar_lea = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-09_jwxyv4.png")
# avatar_simba = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-12_t8w7vy.png")
# avatar_fox = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644926/times%20up%20avatars/times_up___avatar_-13_nvdl5t.png")
# avatar_monkey2 = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-01_adfxjf.png")
# avatar_gorila2 = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-03_mx9203.png")
# avatar_cat = URI.open("https://res.cloudinary.com/doind6rcn/image/upload/v1709644925/times%20up%20avatars/times_up___avatar_-07_fl3xsc.png")

# avatar_arr = [avatar_monkey, avatar_bear, avatar_giraffe, avatar_gorila, avatar_chicken, avatar_lion, avatar_sheep, avatar_tiger, avatar_owl, avatar_polar, avatar_lea, avatar_simba, avatar_fox, avatar_monkey2, avatar_gorila2, avatar_cat]


# puts "Creating 1 creator for team 1..."

# user = User.new(
#   username: Faker::Name.unique.first_name,
#   game_id: Game.first.id,
#   is_creator: true,
#   team_id: Team.find_by(name: 1).id,
#   points_round_1: 0,
#   points_round_2: 0,
#   points_round_3: 0
# )
# avatar = avatar_arr.sample
# # here is where it uploads to cloudinary
# user.photo.attach(io: File.open(avatar), filename: "#{user.username}.png", content_type: "image/png")
# user.save

# puts "Creating 3 joiners for team 1..."
# 3.times do
#   # avatar = select random img from avatar range
#   user = User.new(
#     username: Faker::Name.unique.first_name,
#     game_id: Game.first.id,
#     is_creator: false,
#     team_id: Team.find_by(name: 1).id,
#     points_round_1: 0,
#     points_round_2: 0,
#     points_round_3: 0
#   )
#   avatar = avatar_arr.sample
#   user.photo.attach(io: File.open(avatar), filename: "#{user.username}.png", content_type: "image/png")
#   user.save
# end

# puts "Creating 4 joiners for team 2..."
# 4.times do
#   # avatar = select random img from avatar range
#   user = User.new(
#     username: Faker::Name.unique.first_name,
#     game_id: Game.first.id,
#     is_creator: false,
#     team_id: Team.find_by(name: 2).id,
#     points_round_1: 0,
#     points_round_2: 0,
#     points_round_3: 0
#   )
#   avatar = avatar_arr.sample
#   user.photo.attach(io: File.open(avatar), filename: "#{user.username}.png", content_type: "image/png")
#   user.save
# end
# # 5.times do
# #   Card.new will come here
# # end
