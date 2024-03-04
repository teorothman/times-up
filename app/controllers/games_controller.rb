class GamesController < ApplicationController
  def join
  end

  def perform_join
    @game = Game.find_by(code: params[:game_code])
    if @game
      redirect_to game_path(@game), notice: 'Successfully joined the game!'
    else
      redirect_to join_game_path, alert: 'Game not found.'
    end
  end
end
