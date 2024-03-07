class GamesController < ApplicationController
  helper_method :current_user

  def index
  end

  def create
    @game = Game.new(params[:id])
    @game.is_default = params[:is_default] == 'true'
    @game.save
    @game_state = GamesStatus.create(game_id: @game.id)
    @team_one = Team.create!(name: 1, game_id: @game.id)
    @team_two = Team.create!(name: 2, game_id: @game.id)
    @round_one = Round.create!(game_id: @game.id, round_number: 1)
    @round_two = Round.create!(game_id: @game.id, round_number: 2)
    @round_three = Round.create!(game_id: @game.id, round_number: 3)
    redirect_to new_game_user_path(@game)
  end

  def join
  end

  def update_state
    @game = Game.find(params[:id])
    @game_state = GamesStatus.find_by(game_id: @game.id)
    case @game_state.status
    when "pre-lobby"
      @game_state.status = "lobby"
    end
    render :show
  end


  def show
    #NECCESSARY INSTANCE VARIABLES
    @game = Game.find(params[:id])
    @users = @game.users
    team_one_id = @game.users.first.team_id
    team_two_id = @game.users.second.team_id unless @game.users.second.nil?
    @team_one = @game.users.where(team: team_one_id)
    @team_two = @game.users.where(team: team_two_id) unless @game.users.second.nil?
    @game_state = GamesStatus.find_by(game_id: @game.id)
    team1 = []
    team2 = []
    @team_one.each{|player| team1 << player}
    @team_two.each{|player| team2 << player} unless @team_two.nil?
    @player_order = team1.zip(team2).flatten

    # ACTUAL LOGIC FOR THE GAME
    case @game_state.status
    when 'pre-lobby'
      render 'pre_lobby'
    when 'lobby'
      render 'lobby'
    when 'cards'
      redirect_to new_game_user_card_path(@game, current_user.id)
    when 'round1_play'
      case @game_state.turn_status
      when 'player_selected'
        render 'player_selected'
      when 'player_plays'
        render 'player_plays'
      when 'player_score'
        render 'player_score'
      end
    when 'round1_results'
      render 'round1_results'
    when 'round2_play'
      case @game_state.turn_status
      when 'player_selected'
        render 'player_selected'
      when 'player_plays'
        render 'player_plays'
      when 'player_score'
        render 'player_score'
      end
    when 'round2_results'
      render 'round2_results'
    when 'round3_play'
      case @game_state.turn_status
      when 'player_selected'
        render 'player_selected'
      when 'player_plays'
        render 'player_plays'
      when 'player_score'
        render 'player_score'
      end
    when 'round3_results'
      render 'round3_results'
    when 'results'
      render 'results'
    when 'play_again'
      if current_user.is_creator == true
        render 'play_again'
      else
        render 'results'
      end
    else
      render 'show'
    end
  end

  def perform_join
    @game = Game.find_by(code: params[:game_code])
    if @game
      redirect_to new_game_user_path(@game), notice: 'Successfully joined the game!'
    else
      redirect_to join_game_path, notice: 'Game not found.'
    end
  end

  def update
    @game = Game.find(params[:id])
    game_status = @game.games_status
    game_status.update(status: 'lobby')
    redirect_to game_path(@game)
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
