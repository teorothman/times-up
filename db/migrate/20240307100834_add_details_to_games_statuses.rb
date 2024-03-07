class AddDetailsToGamesStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :games_statuses, :turn_status, :string, default: "player_selected"
    add_column :games_statuses, :start_time, :datetime
    add_column :games_statuses, :card_skipped, :boolean, default: false
    add_column :games_statuses, :current_player, :integer
  end
end
