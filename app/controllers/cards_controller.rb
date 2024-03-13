class CardsController < ApplicationController
  before_action :set_card_count, only: [:new, :create]
  before_action :set_game_and_user

  def new
    @card = Card.new
    redirect_to '#' if current_user.cards.count > 5
  end

  def create
    @card = @user.cards.new(card_params)
    @games_status = GamesStatus.find_by(game_id: @game.id)
    @game = Game.find(params[:game_id])
    @games_status.update(status: "loading")

    # @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    # @player = @player_order[@games_status.turn_counter]

    # @isFirstPlayer = this.playerOrder[0].id

    if @card.save
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 1).id, card_id: @card.id)
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 2).id, card_id: @card.id)
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 3).id, card_id: @card.

      if current_user.cards.count < 5
        redirect_to new_game_user_card_path(@game, @user)
      else
        if check_all_users_submitted
          # 🟢fixing player_order never starts with last guy SUBMITTING CARD
          @games_status.update(team1_starting: true) if current_user.team.name == "2"

          if @games_status.team1_starting == true
            @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
          else
            @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
          end
          @player = @player_order[@games_status.turn_counter]

          @games_status.update(status: "round1_play")
          GameChannel.broadcast_to(
            @game,
            html: render_to_string( partial: "games/player_selected", locals: { game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
            partial: "player_selected",
            user: @player.id
          )
          PlayerChannel.broadcast_to(
            @player,
            html: render_to_string( partial: "games/player_selected_playing", locals: { game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
            partial: "player_selected_playing",
            message: "hello"
          )
          redirect_to game_path(@game)
        else
          redirect_to game_path(@game)
        end
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
