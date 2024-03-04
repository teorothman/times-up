class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.references :game, null: false, foreign_key: true
      t.boolean :is_creator
      t.references :team, null: false, foreign_key: true
      t.integer :points_round_1
      t.integer :points_round_2
      t.integer :points_round_3

      t.timestamps
    end
  end
end
