class SetDefaultValuesForPointsInRounds < ActiveRecord::Migration[7.1]
  def change
    change_column_default :rounds, :points_team1, from: nil, to: 0
    change_column_default :rounds, :points_team2, from: nil, to: 0
  end
end
