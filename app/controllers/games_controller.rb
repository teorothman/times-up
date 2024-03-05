class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:id])
  end

  def show
    @game = Game.find(params[:id])
    # check game state, if not started, waiting room

  end
end
