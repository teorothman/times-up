class UsersController < ApplicationController
  def new
    @user = User.new
    @game = Game.find(params[:game_id])
  end

  def create
    @game = Game.find(params[:game_id])
    @team_one = Team.where(game_id: @game.id).first
    @team_two = Team.where(game_id: @game.id).last
    @user = User.new(user_params)
    @user.game = @game
    if User.where(game_id: @game.id).count.zero?
      @user.is_creator = true
      @user.team_id = @team_one.id
    elsif User.where(game_id: @game.id).count.odd?
      @user.team_id = @team_two.id
    else
      @user.team_id = @team_one.id
    end
    if @user.save
      session[:user_id] = @user.id
      redirect_to game_path(@game)
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
