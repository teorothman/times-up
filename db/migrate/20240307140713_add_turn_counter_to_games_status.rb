class AddTurnCounterToGamesStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :games_statuses, :turn_counter, :integer, default: 0
  end
end
