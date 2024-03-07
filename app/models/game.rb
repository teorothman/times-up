class Game < ApplicationRecord
  has_many :rounds, dependent: :destroy
  has_many :users, dependent: :destroy
  has_one :games_status, dependent: :destroy
  has_many :teams, dependent: :destroy

  # WIP LAURA --> adding points/team in DB
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

  # to be called on game. & ¿passing a team?
  # FILLING user.total_points column
  def mvp_user(team_name)
    # Iterate over each user in the team
    users = users_from_team(team_name)
    users.each do |user|
      # Calculate the total points for the current user
      sum_points = user.points_round_1 + user.points_round_2 + user.points_round_3

      # Store the user ID and total points in the hash
      user.total_points << sum_points
    end

    # returns the user with the highest total_points
    # users_from_team(team_name).select(total_points.max)

    # top_user = users.max_by { |user| user.total_points }
    # top_user.username
  end
end
