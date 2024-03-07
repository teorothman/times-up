class DropTurnsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :turns
  end

  def down
    create_table :turns do |t|
      t.integer :points
      t.bigint :round_id, null: false
      t.bigint :user_id, null: false
      t.boolean :skip_used
      t.integer :timer
      t.timestamps
    end
    add_index :turns, :round_id
    add_index :turns, :user_id
  end

end
