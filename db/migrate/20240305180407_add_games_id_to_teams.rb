class AddGamesIdToTeams < ActiveRecord::Migration[7.1]
  def change
    add_reference :teams, :game, foreign_key: true
  end
end
