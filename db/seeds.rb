require "open-uri"

puts "Dropping current data"
Game.destroy_all
Team.destroy_all
User.destroy_all
Round.destroy_all
Turn.destroy_all


puts "Creating 1 game"
game = Game.create! code: 123456, url: "https://www.instagram.com/p/y-al3LtwsQ/", is_default: true

puts "Creating 2 teams"
Team.create! name: 1, game_id: game.id
Team.create! name: 2, game_id: game.id

# AVATAR SEEDS TO KEEP FOR PRODUCTION > DISPLAY Avatar.all
puts "Loading images for avatars..."
  avatar_monkey = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -01.png")
  avatar_bear = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -02.png")
  avatar_giraffe = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -03.png")
  avatar_gorila = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -04.png")
  avatar_chicken = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -05.png")
  avatar_lion = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -06.png")
  avatar_sheep = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -07.png")
  avatar_tiger = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -08.png")
  avatar_owl = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -09.png")
  avatar_polar = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -10.png")
  avatar_lea = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -11.png")
  avatar_simba = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -12.png")
  avatar_fox = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -13.png")
  avatar_monkey2 = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -14.png")
  avatar_gorila2 = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -15.png")
  avatar_cat = File.open("/Users/Laura/code/lfcavia/times-up/app/assets/images/times up _ avatar -16.png")

avatar_arr = [
  avatar_monkey, avatar_bear, avatar_giraffe, avatar_gorila, avatar_chicken, avatar_lion, avatar_sheep, avatar_tiger, avatar_owl, avatar_polar, avatar_lea, avatar_simba, avatar_fox, avatar_monkey2, avatar_gorila2, avatar_cat
]

puts "Creating avatars..."
n = 0
avatar_arr.each do |img|
  avatar = Avatar.new
  avatar.photo.attach(io: File.open(img), filename: "avatar#{n+=1}.png", content_type: "image/png")
  avatar.save!
end

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
user.photo.attach(io: avatar, filename: "#{user.username}.png", content_type: "image/png")
user.save!

puts "Creating 3 joiners for team 1..."
3.times do
  user = User.new(
    username: Faker::Name.first_name,
    game_id: Game.first.id,
    is_creator: false,
    team_id: Team.find_by(name: 1).id,
    points_round_1: 0,
    points_round_2: 0,
    points_round_3: 0
  )
  # Select random img from avatar array seems to need File.open to open img from variable
  avatar = avatar_arr.sample
  user.photo.attach(io: File.open(avatar_cat), filename: "#{user.username}.png", content_type: "image/png")
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
