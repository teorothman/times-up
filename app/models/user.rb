class User < ApplicationRecord
  belongs_to :game
  belongs_to :team
  has_many :turns
  has_many :cards, dependent: :destroy
  belongs_to :avatar, optional: true

  has_one_attached :photo

  validates :username, presence: true, uniqueness: {scope: :game,
    message: "Oops! Username taken"}
  validates :photo, uniqueness: {scope: :game,
    message: "Oops! Avatar taken!"}
end
