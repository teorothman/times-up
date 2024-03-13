class AddIsTeam1StartingToGamesStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :games_statuses, :IsTeam1Starting, :boolean, default: false
  end
end
