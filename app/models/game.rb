class Game < ApplicationRecord
  has_many :rounds, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :teams, dependent: :destroy
end
