class User < ApplicationRecord
  belongs_to :game
  belongs_to :team
  has_many :turns
  has_many :cards
end
