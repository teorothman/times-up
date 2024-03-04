class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.string :content
      t.references :user, null: false, foreign_key: true
      t.boolean :is_guessed
      t.boolean :is_skipped

      t.timestamps
    end
  end
end
