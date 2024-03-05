class Round < ApplicationRecord
  belongs_to :game
  has_many :turns, dependent: :destroy
end
