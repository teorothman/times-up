class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:id])
    @game.is_default = params[:is_default] == 'true'
    @game.save
    redirect_to new_game_user_path(@game)
  end

  def show
    @game = Game.find(params[:id])
  end
end
