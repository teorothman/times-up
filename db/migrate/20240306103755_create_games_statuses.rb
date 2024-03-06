class CreateGamesStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :games_statuses do |t|
      t.string :status
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
