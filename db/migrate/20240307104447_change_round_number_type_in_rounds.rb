class ChangeRoundNumberTypeInRounds < ActiveRecord::Migration[7.1]
  def change
    change_column :rounds, :round_number, :integer, using: 'round_number::integer'
  end
end
