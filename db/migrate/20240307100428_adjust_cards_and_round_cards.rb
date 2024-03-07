class AdjustCardsAndRoundCards < ActiveRecord::Migration[7.1]
  def change
    remove_column :cards, :is_guessed, :boolean
    remove_column :cards, :is_skipped, :boolean
    add_column :round_cards, :is_guessed, :boolean, default: false
  end
end
