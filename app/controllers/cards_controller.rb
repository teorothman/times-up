class CardsController < ApplicationController
  before_action :set_card_count, only: [:new, :create]
  before_action :set_game_and_user

  def new
    @card = Card.new
    @examples = [ "The Mona Lisa", "Eiffel Tower", "Shrek", "Cleopatra", "The Beatles", "Harry Potter", "Mount Everest", "Albert Einstein",
      "The Sphinx", "Leonardo da Vinci", "Marilyn Monroe", "Titanic", "Pikachu", "Statue of Liberty", "Michael Jackson", "Sherlock Holmes", "The Colosseum", "Elvis Presley", "Star Wars", "Napoleon Bonaparte", "Spider-Man", "The Hobbit", "Big Ben",
      "The Godfather", "Machu Picchu", "Julius Caesar", "Batman", "Stonehenge", "Jurassic Park", "King Arthur", "Charlie Chaplin", "The Roman Empire", "James Bond", "The Grand Canyon", "Mozart", "Steve Jobs",
    ].sample(3)
    redirect_to '#' if session[:card_count] > 5
  end

  def create
    @card = @user.cards.new(card_params)
    if @card.save
      session[:card_count] += 1
      if session[:card_count] <= 5
        redirect_to new_game_user_card_path(@game, @user)
      else
        session[:card_count] = nil
        redirect_to '#'
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
  rescue ActiveRecord::RecordNotFound
    # Handle cases where Game or User doesn't exist
  end
end