class GamesController < ApplicationController
  before_action :cards_rounds_playable, only: [:skip_card, :guess_card, :guess_card_skipped, :play, :show]
  before_action :set_game, only: [:show, :update, :play, :guess_card, :update_state, :skip_card, :guess_card_skipped]
  before_action :set_game_status, only: [:show, :update, :update_state, :play, :guess_card, :guess_card_skipped, :skip_card, :update_turn_status_to_player_score]
  before_action :set_player_order, only: [:show, :update, :play, :guess_card, :guess_card_skipped, :skip_card]
  before_action :set_player, only: [:show, :update, :play, :guess_card, :guess_card_skipped, :skip_card]

  def index
  end

  def create
    @game = Game.new(params[:id])
    @game.is_default = params[:is_default] == 'true'
    @game.save
    @game_status = GamesStatus.create(game_id: @game.id)
    @team_one = Team.create!(name: 1, game_id: @game.id)
    @team_two = Team.create!(name: 2, game_id: @game.id)
    @round_one = Round.create!(game_id: @game.id, round_number: 1)
    @round_two = Round.create!(game_id: @game.id, round_number: 2)
    @round_three = Round.create!(game_id: @game.id, round_number: 3)
    # move Rules to seed as donde w avatars
    @rules = Rule.all
    redirect_to new_game_user_path(@game)
  end

  def join
  end

  def update_state
    @game_status.update(status: 'lobby') if @game_status.status == 'pre_lobby'
    render :show
  end

  def show
    @users = @game.users
    @round1 = Round.find_by(round_number: 1, game_id: @game.id)
    @round2 = Round.find_by(round_number: 2, game_id: @game.id)
    @round3 = Round.find_by(round_number: 3, game_id: @game.id)
    @cards_round1 = RoundCard.where(round_id: @round1.id)
    @cards_round2 = RoundCard.where(round_id: @round2.id)
    @cards_round3 = RoundCard.where(round_id: @round3.id)

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
    @rules = Rule.all

    case @game_status.status
    when 'pre_lobby'
      @game_status.update(status: 'lobby')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: @game_status.status, locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules }),
        partial: "lobby"
      )
    when 'lobby'
      current_user.update(is_ready: true)
      GameChannel.broadcast_to(
        @game,
        {
          html: render_to_string(partial: @game_status.status, locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules }),
          user_id: current_user.id,
          is_ready: true,
          action: 'user_ready'
        })

      if !User.where(game_id: @game.id, is_ready: false).exists?
        @game_status.update(status: 'cards')
        GameChannel.broadcast_to(
          @game,
          {
            html: render_to_string(partial: @game_status.status, locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules }),
            partial: "cards",
          })
      end
    when 'cards'
      GameChannel.broadcast_to(
        @game,
        {
          html: render_to_string(partial: @game_status.status, locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules }),
          partial: "cards",
        })
    when 'round1_play'
      @game_status.update(status: 'round1_results')
    when 'round1_results'
      @game_status.update(status: 'round2_play')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/player_selected", locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, player: @player} ),
        partial: "player_selected",
      )
      PlayerChannel.broadcast_to(
        @player,
        html: render_to_string( partial: "games/player_selected_playing", locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, player: @player} ),
        partial: "player_selected_playing",
      )
    when 'round2_play'
      @game_status.update(status: 'round2_results')
    when 'round2_results'
      @game_status.update(status: 'round3_play')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/player_selected", locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, player: @player} ),
        partial: "player_selected",
      )
      PlayerChannel.broadcast_to(
        @player,
        html: render_to_string( partial: "games/player_selected_playing", locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, player: @player} ),
        partial: "player_selected_playing",
      )
    when 'round3_play'
      @game_status.update(status: 'round3_results')
    when 'round3_results'
      @game_status.update(status: 'results')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/results", locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, player: @player} ),
        partial: "results",
      )
    when 'results'
      @game_status.update(status: 'play_again')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "games/results", locals: { game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, player: @player} ),
        partial: "results",
      )
    end
  end

  def play
    @round1 = Round.find_by(round_number: 1, game_id: @game.id)
    @round2 = Round.find_by(round_number: 2, game_id: @game.id)
    @round3 = Round.find_by(round_number: 3, game_id: @game.id)
    team_one_id = @game.users.first.team_id
    team_two_id = @game.users.second.team_id unless @game.users.second.nil?
    # for clarity these should be named @team_one_users
    @team_one = @game.users.where(team: team_one_id)
    @team_two = @game.users.where(team: team_two_id) unless @game.users.second.nil?

    case @game_status.turn_status
    when 'player_selected'
      @game.update(player_turn_point: 0)
      @game_status.update(turn_status: 'player_plays')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "player_plays", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "player_plays"
      )
      PlayerChannel.broadcast_to(
        @player,
        html: render_to_string( partial: "player_plays_playing", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
        partial: "player_plays_playing"
      )
    when 'player_plays'
      @game_status.update(turn_status: 'player_score')
      GameChannel.broadcast_to(
        @game,
        html: render_to_string( partial: "player_score", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
        partial: "player_score"
      )
      PlayerChannel.broadcast_to(
        @player,
        html: render_to_string( partial: "player_score_playing", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
        partial: "player_score_playing"
      )
    when 'player_score'
      if @cards_round3_playable.count.zero? && @game_status.status == "round3_play"
        GameChannel.broadcast_to(
          @game,
          html: render_to_string( partial: "round3_results", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "round3_results",
        )
        PlayerChannel.broadcast_to(
          @player,
          html: render_to_string( partial: "round3_results_playing", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
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
          html: render_to_string( partial: "round2_results", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "round2_results",
        )
        PlayerChannel.broadcast_to(
          @player,
          html: render_to_string( partial: "round2_results_playing", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
          partial: "round2_results"
        )
      elsif @cards_round1_playable.count.zero? && @game_status.status == "round1_play"
        GameChannel.broadcast_to(
          @game,
          html: render_to_string( partial: "round1_results", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "round1_results",
        )
        PlayerChannel.broadcast_to(
          @player,
          html: render_to_string( partial: "round1_results_playing", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable } ),
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
          html: render_to_string( partial: "player_selected", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "player_selected",
        )
        PlayerChannel.broadcast_to(
          @player,
          html: render_to_string( partial: "player_selected_playing", locals: { player: @player, game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user} ),
          partial: "player_selected_playing",
        )
      end
    end
  end

  def guess_card
    @team_number = current_user.team.name.to_i
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
      html: render_to_string( partial: "card_playing", locals: {game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable} ),
      partial: "card_playing",
    )
    head :ok
  end

  def guess_card_skipped
    @team_number = current_user.team.name.to_i

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
      html: render_to_string( partial: "player_plays_playing_skipped", locals: {  game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable} ),
      partial: "player_plays_playing_skipped",
    )
  end

  def skip_card
    card_round = RoundCard.find(params[:card_round_id])


    PlayerChannel.broadcast_to(
      @player,
      html: render_to_string(partial: "player_plays_playing_skipped", locals: {game: @game, users: @game.users, game_status: @game_status, player_order: @player_order, rules: @rules, current_user: current_user, cards_round1_playable: @cards_round1_playable, cards_round2_playable: @cards_round2_playable, cards_round3_playable: @cards_round3_playable} ),
      partial: "player_plays_playing_skipped",
    )
  end

  def update_turn_status_to_player_score
    @game_status.update(turn_status: 'player_score')
    redirect_to game_path(@game), notice: "Time's up! Moving to score."
  end

  def show_qr
    render partial: 'new_modal'
  end

  # CARDS

  def create_card
    @game = Game.find(params[:id])
    @user = current_user
    @card = @user.cards.new(card_params)
    @games_status = GamesStatus.find_by(game_id: @game.id)

    if @card.save
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 1).id, card_id: @card.id)
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 2).id, card_id: @card.id)
      RoundCard.create(round_id: Game.last.rounds.find_by(round_number: 3).id, card_id: @card.id)

      if current_user.cards.count < 4
        redirect_to game_path(@game, @user)
      else
        if check_all_users_submitted
          @games_status.update(team1_starting: true) if current_user.team.name == "2"
          if @games_status.team1_starting == true
            @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten
          else
            @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten
          end
          @player = @player_order[@games_status.turn_counter]

          @games_status.update(status: "round1_play")
          GameChannel.broadcast_to(
            @game,
            html: render_to_string( partial: "player_selected", locals: {player: @player, game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
            partial: "player_selected"
          )
          PlayerChannel.broadcast_to(
            @player,
            html: render_to_string( partial: "player_selected_playing", locals: {player: @player, game: @game, users: @game.users, game_state: @game_state, player_order: @player_order, rules: @rules, current_user: current_user} ),
            partial: "player_selected_playing"
          )
          redirect_to game_path(@game)
        else
          redirect_to game_path(@game, loading: true)
        end
      end
    else
      render :new
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def set_game_status
    @game_status = GamesStatus.find_by(game_id: @game.id)
  end

  def set_card_count
    session[:card_count] ||= 1
  end

  def card_params
    params.require(:card).permit(:content)
  end

  def check_all_users_submitted
    total_cards_needed = @game.users.count * 4
    Card.joins(user: :game).where(users: {game_id: @game.id}).count >= total_cards_needed
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def set_player_order
    @player_order = @game.teams.first.users.to_a.zip(@game.teams.second.users).flatten if @game_status.team1_starting
    @player_order = @game.teams.second.users.to_a.zip(@game.teams.first.users).flatten unless @game_status.team1_starting
  end

  def cards_rounds_playable
    @game ||= Game.find(params[:id])
    @round1 = @game.rounds.find_by(round_number: 1)
    @round2 = @game.rounds.find_by(round_number: 2)
    @round3 = @game.rounds.find_by(round_number: 3)
    @cards_round1_playable = RoundCard.where(round_id: @round1.id).where(is_guessed: false)
    @cards_round2_playable = RoundCard.where(round_id: @round2.id).where(is_guessed: false)
    @cards_round3_playable = RoundCard.where(round_id: @round3.id).where(is_guessed: false)
  end

  def set_player
    @player = @player_order[@game_status.turn_counter]
  end
end
