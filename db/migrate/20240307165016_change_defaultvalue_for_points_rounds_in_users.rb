class ChangeDefaultvalueForPointsRoundsInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :points_round_1, from: nil, to: 0

    change_column_default :users, :points_round_2, from: nil, to: 0

    change_column_default :users, :points_round_3, from: nil, to: 0
  end
end
