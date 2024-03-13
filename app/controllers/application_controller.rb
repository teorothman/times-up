class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :player_order

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def player_order
    @game = Game.find(params[:id])
    @games_status = @game.games_status
    if @games_status.team1_starting == true
      @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    else
      @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
    end
  end
end
