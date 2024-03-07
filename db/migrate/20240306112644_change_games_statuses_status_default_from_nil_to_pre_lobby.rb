class ChangeGamesStatusesStatusDefaultFromNilToPreLobby < ActiveRecord::Migration[7.1]
  def change
    change_column_default :games_statuses, :status, from: nil, to: "pre-lobby"
  end
end
