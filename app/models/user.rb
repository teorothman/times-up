class User < ApplicationRecord
  belongs_to :game
  belongs_to :team
  has_many :turns
  has_many :cards, dependent: :destroy

  has_one_attached :photo

  validates :username, presence: true, uniqueness: { scope: :game_id }
end
