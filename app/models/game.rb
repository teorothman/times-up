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

  def users_from_team(name)
    team = Team.find_by(name: name)
    users.where(team_id: team.id)
  end

  # to be called on game. & ¿passing a team?
  # FILLING user.total_points column
  def mvp_user(team)

    # Iterate over each user in the team
    team.users.each do |user|
      # Calculate the total points for the current user
      sum_points = user.points_round_1 + user.points_round_2 + user.points_round_3

      # Store the user ID and total points in the hash
      user.total_points << sum_points
    end

    # should return the user with the higher total_points
    team.users.select(total_points.max)
  end
end
