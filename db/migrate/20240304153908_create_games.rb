class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :code
      t.string :url
      t.boolean :is_default

      t.timestamps
    end
  end
end
