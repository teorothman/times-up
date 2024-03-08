class ChangeGameStatusStatusDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default :games_statuses, :status, from: 'pre-lobby', to: 'pre_lobby'
  end
end
