class Game < ApplicationRecord
  has_many :rounds, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :games_statuses, dependent: :destroy
  has_many :teams, dependent: :destroy

  # WIP LAURA --> adding points/team in DB
  def total_points_T1(game)
    game.rounds.pluck(:points_team1).compact.sum
  end

  def total_points_T2(game)
    game.rounds.pluck(:points_team2).compact.sum
  end
end
