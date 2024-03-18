class Game < ApplicationRecord
  has_many :rounds, dependent: :destroy
  has_many :users, dependent: :destroy
  has_one :games_status, dependent: :destroy
  has_many :teams, dependent: :destroy

  def total_points_T1(game)
    game.rounds.pluck(:points_team1).compact.sum
  end

  def total_points_T2(game)
    game.rounds.pluck(:points_team2).compact.sum
  end

  # Team.name is a string "1" or "2"
  def users_from_team(team_name)
    team = Team.find_by(name: team_name)
    users.where(team_id: team.id)
  end

  def mvp_1
    team_one = self.teams.find_by(name: "1")
    team_one_id = team_one.id
    team_one_users = team_one.users.where(team: team_one_id)
    team_one_users.order(:total_points).first
  end

  def mvp_2
    team_two = self.teams.find_by(name: "2")
    team_two_id = team_two.id
    team_two_users = team_two.users.where(team: team_two_id)
    team_two_users.order(:total_points).first
  end

  # to call .points_team_1 on it
  def round_1
    rounds.find_by(round_number: 1)
  end

  def round_2
    rounds.find_by(round_number: 2)
  end

  def round_3
    rounds.find_by(round_number: 3)
  end
end
