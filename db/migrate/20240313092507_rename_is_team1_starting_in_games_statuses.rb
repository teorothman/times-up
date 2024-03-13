class RenameIsTeam1StartingInGamesStatuses < ActiveRecord::Migration[7.1]
  def change
    rename_column :games_statuses, :IsTeam1Starting, :team1_starting
  end
end
