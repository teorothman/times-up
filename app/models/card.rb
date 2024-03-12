class Card < ApplicationRecord
  belongs_to :user
  has_many :round_cards, dependent: :destroy
  has_many :rounds, through: :round_cards
  validates :content, presence: { message: "A card should not be empty!" }
end
