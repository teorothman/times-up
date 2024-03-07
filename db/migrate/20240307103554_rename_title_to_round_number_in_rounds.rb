class RenameTitleToRoundNumberInRounds < ActiveRecord::Migration[7.1]
  def change
    rename_column :rounds, :title, :round_number
  end
end
