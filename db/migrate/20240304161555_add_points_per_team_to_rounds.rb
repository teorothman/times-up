class AddPointsPerTeamToRounds < ActiveRecord::Migration[7.1]
  def change
    add_column :rounds, :points_per_team, :integer
  end
end
