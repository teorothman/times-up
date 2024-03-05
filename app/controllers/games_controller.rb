class GamesController < ApplicationController
  def index
  end

  def create
    @game = Game.new(params[:id])
    @game.is_default = params[:is_default] == 'true'
    @game.save
    redirect_to new_game_user_path(@game)
  end

  def join
  end


  def show
    @game = Game.find(params[:id])

    # check game state, if not started, waiting room
    @users = @game.users
    team_one_id = @game.users.first.team_id
    team_two_id = @game.users.second.team_id
    @team_one = @game.users.where(team: team_one_id)
    @team_two = @game.users.where(team: team_two_id)
    render 'lobby'
    # render 'pre_lobby'
    # check game state, if not started, waiting room

  def perform_join
    @game = Game.find_by(code: params[:game_code])
    if @game
      redirect_to new_game_user_path(@game), notice: 'Successfully joined the game!'
    else
      redirect_to join_game_path, notice: 'Game not found.'
    end
  end

end
