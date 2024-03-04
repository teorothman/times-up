class CreateTurns < ActiveRecord::Migration[7.1]
  def change
    create_table :turns do |t|
      t.integer :points
      t.references :round, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :skip_used
      t.integer :timer

      t.timestamps
    end
  end
end
