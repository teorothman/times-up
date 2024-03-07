class ChangePointsTeam1InRoundsToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :rounds, :points_team2, :integer, using: 'points_team2::integer'
  end
end
