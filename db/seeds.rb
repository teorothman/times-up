require "open-uri"

puts "Dropping current data"
User.destroy_all
Card.destroy_all
Team.destroy_all
Game.destroy_all
Round.destroy_all
Avatar.destroy_all
Rule.destroy_all



puts "Creating 1 game"
game = Game.create! code: 123456, url: "https://www.instagram.com/p/y-al3LtwsQ/", is_default: true

puts "Creating 2 teams"
Team.create! name: 1, game_id: game.id
Team.create! name: 2, game_id: game.id

# AVATAR SEEDS TO KEEP FOR PRODUCTION > DISPLAY Avatar.all
puts "Loading images for avatars..."
  avatar_monkey = File.open("app/assets/images/avatar_1.png")
  avatar_bear = File.open("app/assets/images/avatar_2.png")
  avatar_giraffe = File.open("app/assets/images/avatar_3.png")
  avatar_gorila = File.open("app/assets/images/avatar_4.png")
  avatar_chicken = File.open("app/assets/images/avatar_5.png")
  avatar_lion = File.open("app/assets/images/avatar_6.png")
  avatar_sheep = File.open("app/assets/images/avatar_7.png")
  avatar_tiger = File.open("app/assets/images/avatar_8.png")
  avatar_owl = File.open("app/assets/images/avatar_9.png")
  avatar_polar = File.open("app/assets/images/avatar_10.png")
  avatar_lea = File.open("app/assets/images/avatar_11.png")
  avatar_simba = File.open("app/assets/images/avatar_12.png")
  avatar_fox = File.open("app/assets/images/avatar_13.png")
  avatar_monkey2 = File.open("app/assets/images/avatar_14.png")
  avatar_gorila2 = File.open("app/assets/images/avatar_15.png")
  avatar_cat = File.open("app/assets/images/avatar_16.png")

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

# puts "Creating 40 cards"
# times_up_guess_list = [
#   "The Mona Lisa",
#   "Eiffel Tower",
#   "Shrek",
#   "Cleopatra",
#   "The Beatles",
#   "Harry Potter",
#   "Mount Everest",
#   "Albert Einstein",
#   "The Sphinx",
#   "Leonardo da Vinci",
#   "Marilyn Monroe",
#   "Titanic",
#   "Pikachu",
#   "Statue of Liberty",
#   "Michael Jackson",
#   "Sherlock Holmes",
#   "The Colosseum",
#   "Elvis Presley",
#   "Star Wars",
#   "Napoleon Bonaparte",
#   "Spider-Man",
#   "The Hobbit",
#   "Big Ben",
#   "Vincent van Gogh",
#   "Queen Elizabeth II",
#   "The Godfather",
#   "Machu Picchu",
#   "Julius Caesar",
#   "Batman",
#   "Stonehenge",
#   "William Shakespeare",
#   "Frida Kahlo",
#   "Jurassic Park",
#   "King Arthur",
#   "Charlie Chaplin",
#   "James Bond",
#   "The Grand Canyon",
#   "Mozart",
#   "The Wizard of Oz",
#   "Steve Jobs",
# ]


# times_up_guess_list.each do |word|
#   card = Card.new(
#     content: word,
#     user_id: User.first.id,
#     is_guessed: false,
#     is_skipped: false
#   )
#   card.save
# end

rule = Rule.create!(
  title: "Times Up",
  content: "Time's up is played in three different rounds. and the team with the most points at the end of the three rounds win. Easy, right?

  Before we start however, each player must enter five words. The words can be whatever, so use your imagination. But it should be something everyone knows. Maybe your favorite food, an actor you adore or a famous building."
)
rule.save

rule = Rule.create!(
  title: "Round 1",
  content: "A player from team 1 is chosen at random. The player will be notified on the screen and has to stand up and get ready. The player will see a card with a word written by one of you on it. The players task is to make you guess the word, but you can't obviously say the word (in any language). No pointing either!!!

  If you guess right, you get a point! And the chosen player can advance to the next card. Continue until the Time's up. Next up is Team 2.

  This continues until all words in the pool are guessed correctly."
)
rule.save

rule = Rule.create!(
  title: "Round 2",
  content: "This round is a lot similar to the first. But with one key difference. You can't speak. Your task is now to mimic and act out the word to the best of your ability. Release your inner Hollywood superstar and make your teammates proud.

  To make this not all out impossible. The words you have to act out, are the same words your team managed to successfully guess correct in the first round!

  Each team gets 1 minute each. "
)
rule.save

rule = Rule.create!(
  title: "Round 3",
  content: "The final round. This time it's no more acting and you can finally use your sweet voice again. But there is one catch. You can only use one word. After you have said one word, you can't speak again until your team guesses correctly or you pass!

  So chose your word carefully!

  Each team gets 1 minute. "
)
rule.save
