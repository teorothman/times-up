class CreateRoundCards < ActiveRecord::Migration[7.1]
  def change
    create_table :round_cards do |t|
      t.references :round, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
