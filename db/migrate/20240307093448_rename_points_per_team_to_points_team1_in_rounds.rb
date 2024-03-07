class RenamePointsPerTeamToPointsTeam1InRounds < ActiveRecord::Migration[7.1]
  def change
    rename_column :rounds, :points_per_team, :points_team1

    add_column :rounds, :points_team2, :string
  end
end
