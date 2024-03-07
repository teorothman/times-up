class Change1RoundNumberTypeInRounds < ActiveRecord::Migration[7.1]
  def change
    change_column_default :rounds, :round_number, from: nil, to: 1
  end
end
