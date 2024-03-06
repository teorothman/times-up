class Card < ApplicationRecord
  belongs_to :user
  has_many :round_cards
  has_many :rounds, through: :round_cards
end
