class CardsController < ApplicationController
  before_action :set_card_count, only: [:new, :create]
  before_action :set_game_and_user

  def new
    @card = Card.new
    @examples = [ "The Mona Lisa", "Eiffel Tower", "Shrek", "Cleopatra", "The Beatles", "Harry Potter", "Mount Everest", "Albert Einstein",
      "The Sphinx", "Leonardo da Vinci", "Marilyn Monroe", "Titanic", "Pikachu", "Statue of Liberty", "Michael Jackson", "Sherlock Holmes", "The Colosseum", "Elvis Presley", "Star Wars", "Napoleon Bonaparte", "Spider-Man", "The Hobbit", "Big Ben",
      "The Godfather", "Machu Picchu", "Julius Caesar", "Batman", "Stonehenge", "Jurassic Park", "King Arthur", "Charlie Chaplin", "The Roman Empire", "James Bond", "The Grand Canyon", "Mozart", "Steve Jobs",
    ].sample(3)
    redirect_to '#' if current_user.cards.count > 5
  end

  def create
    @card = @user.cards.new(card_params)
    @games_status = GamesStatus.find_by(game_id: @game.id)
    @game = Game.find(params[:game_id])
    @games_status.update(status: "loading")

    @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    @player = @player_order[@games_status.turn_counter]

    if @card.save
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 1).id, card_id: @card.id)
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 2).id, card_id: @card.id)
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 3).id, card_id: @card.id)
      if current_user.cards.count < 5
        redirect_to new_game_user_card_path(@game, @user)
      else
        redirect_to game_path(@game)
      end
    else
      render :new
    end
  end

  private

  def set_card_count
    session[:card_count] ||= 1
  end

  def card_params
    params.require(:card).permit(:content)
  end

  def set_game_and_user
    @game = Game.find(params[:game_id])
    @user = User.find(params[:user_id])
  end

  def check_all_users_submitted
    total_cards_needed = @game.users.count * 5
    Card.joins(user: :game).where(users: {game_id: @game.id}).count >= total_cards_needed
  end
end
