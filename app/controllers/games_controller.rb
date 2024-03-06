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
    if params[:update_game]
      case @game_state.status
      when "pre-lobby"
        @game_state.update(status: 'lobby')
      when "lobby"
        @game_state.update(status: 'cards')
      when "cards"
        @game_state.update(status: 'round')
      when "round"
        @game_state.update(status: 'results')
      when "results"
        @game_state.update(status: 'play_again')
      when "play_again"
        @game_state.update(status: 'lobby')
      end
    end

    # ACTUAL LOGIC FOR THE GAME
    case @game_state.status
    when 'pre-lobby'
      render 'pre_lobby'
    when 'lobby'
      render 'lobby'
    when 'cards'
      render 'cards'
    when 'round'
      render 'round'
    when 'results'
      render 'results'
    # Laura
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

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
