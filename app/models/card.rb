class Card < ApplicationRecord
  belongs_to :user
  has_many :round_cards, dependent: :destroy
  has_many :rounds, through: :round_cards
  validates :content, presence: { message: "A card should not be empty!" }
  validate :content_must_be_unique_within_game

  private

  def content_must_be_unique_within_game
    existing_card = Card.joins(:user).where(content: content, users: {game_id: user.game_id}).where.not(id: id).exists?
    errors.add(:content, "This word has already been entered!") if existing_card
  end
end
