class ChangeCategoryInRoundsToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :rounds, :title, :integer, default: 1, null: false
    rename_column :rounds, :title, :round_number
  end
end
