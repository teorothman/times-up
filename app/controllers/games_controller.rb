class GamesController < ApplicationController
  #tbd if needed ot be mention here
  helper_method :current_user


  def index
  end

  def create
    @game = Game.new(params[:id])
    @game.is_default = params[:is_default] == 'true'
    @game.save
    @game_state = GamesStatus.create(game_id: @game.id)
    @team_one = Team.create!(name: 1, game_id: @game.id)
    @team_two = Team.create!(name: 2, game_id: @game.id)
    @round_one = Round.create!(game_id: @game.id, round_number: 1)
    @round_two = Round.create!(game_id: @game.id, round_number: 2)
    @round_three = Round.create!(game_id: @game.id, round_number: 3)
    @rules = Rule.all
    redirect_to new_game_user_path(@game)
  end

  def join
  end

  def update_state
    @game = Game.find(params[:id])
    @game_state = GamesStatus.find_by(game_id: @game.id)
    case @game_state.status
    when "pre_lobby"
      @game_state.status = "lobby"
    end
    render :show
  end


  def show
    #NECCESSARY INSTANCE VARIABLES
    @game = Game.find(params[:id])
    @users = @game.users

    @game_state = GamesStatus.find_by(game_id: @game.id)
    @round1 = Round.find_by(round_number: 1, game_id: @game.id)
    @round2 = Round.find_by(round_number: 2, game_id: @game.id)
    @round3 = Round.find_by(round_number: 3, game_id: @game.id)
    @cards_round1 = RoundCard.where(round_id: @round1.id)
    @cards_round2 = RoundCard.where(round_id: @round2.id)
    @cards_round3 = RoundCard.where(round_id: @round3.id)

    redirect_to new_game_user_card_path(@game, current_user.id) if @game_state.status == 'cards'

    # Returns cards per round that are not guessed yet (either skipped or unused)
    @cards_round1_playable = RoundCard.where(round_id: @round1.id).where(is_guessed: false)
    @cards_round2_playable = RoundCard.where(round_id: @round2.id).where(is_guessed: false)
    @cards_round3_playable = RoundCard.where(round_id: @round3.id).where(is_guessed: false)

    @game = Game.find(params[:id])
    @game_status = @game.games_status
    if @game_state.team1_starting == true
      @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    else
      @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
    end
    @player = @player_order[@game_state.turn_counter]

  end

  def perform_join
    @game = Game.find_by(code: params[:game_code])
    if @game
      redirect_to new_game_user_path(@game), notice: 'Successfully joined the game!'
    else
      redirect_to join_game_path, notice: 'Game not found.'
    end
  end

  def update
    @game = Game.find(params[:game_id])
    @game_status = @game.games_status
    @rules = Rule.all
    if @game_status.team1_starting == true
      @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    else
      @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
    end
    @player = @player_order[@game_status.turn_counter]

    case @game_status.status
    when 'pre_lobby'
      @game_status.update(status: 'lobby')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: @game_status.status, locals: { game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules }),
        partial: "lobby"
      )
    when 'lobby'
      current_user.update(is_ready: true)
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: @game_status.status, locals: { game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules } ),
        partial: "lobby"
      )
      !User.where(game_id: @game.id, is_ready: false).exists? ? @game_status.update(status: 'cards') : ''
    when 'round1_play'
      @game_status.update(status: 'round1_results')
    when 'round1_results'
      @game_status.update(status: 'round2_play')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/player_selected", locals: { game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "player_selected",
      )
      PlayerChannel.broadcast_to(
        @player,
        html: render_to_string( partial: "games/player_selected_playing", locals: { game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "player_selected_playing",
      )
    when 'round2_play'
      @game_status.update(status: 'round2_results')
    when 'round2_results'
      @game_status.update(status: 'round3_play')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/player_selected", locals: { game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "player_selected",
      )
      PlayerChannel.broadcast_to(
        @player,
        html: render_to_string( partial: "games/player_selected_playing", locals: { game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "player_selected_playing",
      )
    when 'round3_play'
      @game_status.update(status: 'round3_results')
    when 'round3_results'
      @game_status.update(status: 'results')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/results", locals: { game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "results",
      )
    when 'results'
      @game_status.update(status: 'play_again')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/results", locals: { game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "results",
      )
    end
  end

  def play
    @game = Game.find(params[:game_id])
    @game_status = @game.games_status
    @round1 = Round.find_by(round_number: 1, game_id: @game.id)
    @round2 = Round.find_by(round_number: 2, game_id: @game.id)
    @round3 = Round.find_by(round_number: 3, game_id: @game.id)
    @cards_round1_playable = RoundCard.where(round_id: @round1.id).where(is_guessed: false)
    @cards_round2_playable = RoundCard.where(round_id: @round2.id).where(is_guessed: false)
    @cards_round3_playable = RoundCard.where(round_id: @round3.id).where(is_guessed: false)
    team_one_id = @game.users.first.team_id
    team_two_id = @game.users.second.team_id unless @game.users.second.nil?
    # for clarity these should be named @team_one_users
    @team_one = @game.users.where(team: team_one_id)
    @team_two = @game.users.where(team: team_two_id) unless @game.users.second.nil?

    @game = Game.find(params[:game_id])
    if @game_status.team1_starting == true
      @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    else
      @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
    end
    @player = @player_order[@game_status.turn_counter]

    case @game_status.turn_status
    when 'player_selected'
      @game.update(player_turn_point: 0)
      @game_status.update(turn_status: 'player_plays')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/player_plays", locals: { player: @player, game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "player_plays"
      )
      PlayerChannel.broadcast_to(
        @player,
        html: render_to_string( partial: "games/player_plays_playing", locals: { player: @player, game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
        partial: "player_plays_playing"
      )
    when 'player_plays'
      @game_status.update(turn_status: 'player_score')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "player_score", locals: { player: @player, game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "player_score"
      )
      PlayerChannel.broadcast_to(
        @player,
        html: render_to_string( partial: "player_score_playing", locals: { player: @player, game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
        partial: "player_score_playing"
      )
    when 'player_score'
      if @cards_round3_playable.count.zero? && @game_status.status == "round3_play"
        GameChannel.broadcast_to(
          @game,
          html: render_to_string( partial: "games/round3_results", locals: { player: @player, game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "round3_results",
        )
        PlayerChannel.broadcast_to(
          @player,
          html: render_to_string( partial: "games/round3_results_playing", locals: { player: @player, game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
          partial: "round3_results"
        )
        @game_status.update(turn_counter: @game_status.turn_counter + 1)
        @game_status.update(turn_counter: 0) if @game_status.turn_counter > @player_order.count - 1
        @game_status.update(status: 'round3_results')
        @game_status.update(turn_status: 'player_selected')
        @game.update(player_turn_point: 0)
        @player = @player_order[@game_status.turn_counter]
      elsif @cards_round2_playable.count.zero? && @game_status.status == "round2_play"
        @game_status.update(turn_counter: @game_status.turn_counter + 1)
        @game_status.update(turn_counter: 0) if @game_status.turn_counter > @player_order.count - 1
        @game_status.update(status: 'round2_results')
        @game_status.update(turn_status: 'player_selected')
        @game.update(player_turn_point: 0)
        @player = @player_order[@game_status.turn_counter]
        GameChannel.broadcast_to(
          @game,
          html: render_to_string( partial: "games/round2_results", locals: { player: @player, game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "round2_results",
        )
        PlayerChannel.broadcast_to(
          @player,
          html: render_to_string( partial: "games/round2_results_playing", locals: { player: @player, game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
          partial: "round2_results"
        )
      elsif @cards_round1_playable.count.zero? && @game_status.status == "round1_play"
        GameChannel.broadcast_to(
          @game,
          html: render_to_string( partial: "games/round1_results", locals: { player: @player, game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "round1_results",
        )
        PlayerChannel.broadcast_to(
          @player,
          html: render_to_string( partial: "games/round1_results_playing", locals: { player: @player, game: @game, users: @game.users, game_state: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
          partial: "round1_results"
        )
        @game_status.update(turn_counter: @game_status.turn_counter + 1)
        @game_status.update(turn_counter: 0) if @game_status.turn_counter > @player_order.count - 1
        @game_status.update(status: 'round1_results')
        @game_status.update(turn_status: 'player_selected')
        @game.update(player_turn_point: 0)
        @player = @player_order[@game_status.turn_counter]
      else
        @game_status.update(turn_counter: @game_status.turn_counter + 1)
        @game_status.update(turn_counter: 0) if @game_status.turn_counter > @player_order.count - 1
        @game_status.update(turn_status: 'player_selected')
        @game.update(player_turn_point: 0)
        @player = @player_order[@game_status.turn_counter]
        GameChannel.broadcast_to(
          @game,
          html: render_to_string( partial: "games/player_selected", locals: { player: @player, game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "player_selected",
        )
        PlayerChannel.broadcast_to(
          @player,
          html: render_to_string( partial: "games/player_selected_playing", locals: { player: @player, game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "player_selected_playing",
        )
      end
    end
  end

  def guess_card
    @game = Game.find(params[:id])
    @game_state = @game.games_status
    if @game_state.team1_starting == true
      @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    else
      @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
    end
    @player = @player_order[@game_state.turn_counter]
    @team_number = current_user.team.name.to_i
    @round1 = @game.rounds.find_by(round_number: 1)
    @round2 = @game.rounds.find_by(round_number: 2)
    @round3 = @game.rounds.find_by(round_number: 3)
    @cards_round1_playable = RoundCard.where(round_id: @round1.id).where(is_guessed: false)
    @cards_round2_playable = RoundCard.where(round_id: @round2.id).where(is_guessed: false)
    @cards_round3_playable = RoundCard.where(round_id: @round3.id).where(is_guessed: false)
    if @game.games_status.status == 'round1_play'
      @round1.points_team1 += 1 if @team_number == 1
      @round1.points_team2 += 1 if @team_number == 2
      current_user.points_round_1 += 1
      @round1.save!
    elsif @game.games_status.status == 'round2_play'
      @round2.points_team1 += 1 if @team_number == 1
      @round2.points_team2 += 1 if @team_number == 2
      current_user.points_round_2 += 1
      @round2.save!
    elsif @game.games_status.status == 'round3_play'
      @round3.points_team1 += 1 if @team_number == 1
      @round3.points_team2 += 1 if @team_number == 2
      current_user.points_round_3 += 1
      @round3.save!
    end
    current_user.total_points += 1
    current_user.save
    @game.player_turn_point += 1
    @game.save
    card_round = RoundCard.find(params[:card_round_id])
    card_round.update!(is_guessed: true)
    PlayerChannel.broadcast_to(
      @player,
      html: render_to_string( partial: "card_playing", locals: {  game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable} ),
      partial: "card_playing",
    )
  end

  def guess_card_skipped
    @game = Game.find(params[:id])
    @game_state = @game.games_status
    if @game_state.team1_starting == true
      @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    else
      @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
    end
    @player = @player_order[@game_state.turn_counter]
    @team_number = current_user.team.name.to_i
    @round1 = @game.rounds.find_by(round_number: 1)
    @round2 = @game.rounds.find_by(round_number: 2)
    @round3 = @game.rounds.find_by(round_number: 3)
    @cards_round1_playable = RoundCard.where(round_id: @round1.id).where(is_guessed: false)
    @cards_round2_playable = RoundCard.where(round_id: @round2.id).where(is_guessed: false)
    @cards_round3_playable = RoundCard.where(round_id: @round3.id).where(is_guessed: false)
    if @game.games_status.status == 'round1_play'
      @round1.points_team1 += 1 if @team_number == 1
      @round1.points_team2 += 1 if @team_number == 2
      current_user.points_round_1 += 1
      @round1.save!
    elsif @game.games_status.status == 'round2_play'
      @round2.points_team1 += 1 if @team_number == 1
      @round2.points_team2 += 1 if @team_number == 2
      current_user.points_round_2 += 1
      @round2.save!
    elsif @game.games_status.status == 'round3_play'
      @round3.points_team1 += 1 if @team_number == 1
      @round3.points_team2 += 1 if @team_number == 2
      current_user.points_round_3 += 1
      @round3.save!
    end
    current_user.total_points += 1
    current_user.save
    @game.player_turn_point += 1
    @game.save
    card_round = RoundCard.find(params[:card_round_id])
    card_round.update!(is_guessed: true)
    PlayerChannel.broadcast_to(
      @player,
      html: render_to_string( partial: "player_plays_playing_skipped", locals: {  game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable} ),
      partial: "player_plays_playing_skipped",
    )
  end

  def skip_card
    @game = Game.find(params[:id])
    @game_state = @game.games_status
    if @game_state.team1_starting == true
      @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
    else
      @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
    end
    @player = @player_order[@game_state.turn_counter]
    card_round = RoundCard.find(params[:card_round_id])
    @round1 = @game.rounds.find_by(round_number: 1)
    @round2 = @game.rounds.find_by(round_number: 2)
    @round3 = @game.rounds.find_by(round_number: 3)
    @cards_round1_playable = RoundCard.where(round_id: @round1.id).where(is_guessed: false)
    @cards_round2_playable = RoundCard.where(round_id: @round2.id).where(is_guessed: false)
    @cards_round3_playable = RoundCard.where(round_id: @round3.id).where(is_guessed: false)

    PlayerChannel.broadcast_to(
      @player,
      html: render_to_string( partial: "player_plays_playing_skipped", locals: {game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable} ),
      partial: "player_plays_playing_skipped",
    )
  end

  def update_turn_status_to_player_score
    @game = Game.find(params[:id])
    @game_status = @game.games_status

    @game_status.update(turn_status: 'player_score')

    redirect_to game_path(@game), notice: 'Time´s up! Moving to score.'
  end

  def show_qr
    render partial: 'new_modal'
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

end
