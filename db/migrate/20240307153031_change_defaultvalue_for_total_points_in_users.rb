class ChangeDefaultvalueForTotalPointsInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :total_points, from: nil, to: 0
  end
end
