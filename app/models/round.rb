class Round < ApplicationRecord
  belongs_to :game
  has_many :round_cards
  has_many :cards, through: :round_cards
end
