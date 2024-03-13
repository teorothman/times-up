class User < ApplicationRecord
  belongs_to :game
  belongs_to :team
  has_many :turns
  has_many :cards, dependent: :destroy
  belongs_to :avatar, optional: true

  # UNDOING photo.attach to User
  # has_one_attached :photo

  validates :username, presence: true, uniqueness: {scope: :game,
    message: "Oops! Username taken"}

    validates :avatar_id, presence: true, uniqueness: {scope: :game, message: "Oops! Avatar taken!"}

    validates :avatar_id, presence: { message: "You need to choose an avatar!" }
end
