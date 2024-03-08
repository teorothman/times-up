class AddPlayerTurnPointToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :player_turn_point, :integer, default: 0
  end
end
