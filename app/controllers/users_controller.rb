class UsersController < ApplicationController
  def new
    @user = User.new
    @game = Game.find(params[:game_id])
  end

  def create
    @game = Game.find(params[:game_id])
    @user = User.new(user_params)
    @user.game = @game
    @team = Team.create(name: "")
    @user.team = @team
    if @user.save
      @game.users << @user
      @user.is_creator = true if @game.users.length == 1
      @user.team.name = 'Team 1' if @game.users[0] == @user || @game.users[2] == @user
      @user.team.name = 'Team 2' if @game.users[1] == @user || @game.users[3] == @user
      @user.save
      @team.save
      redirect_to game_path(@game)
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
