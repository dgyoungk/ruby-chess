# './lib/game.rb'
require_relative 'board'
require_relative 'player'
require './lib/modules/chess_logic.rb'
require './lib/game_pieces/queen.rb'

class Game
  include ChessLogic

  attr_accessor :board, :game_finished, :turn, :replay, :players

  attr_reader :player_colors, :alt_colors

  def initialize
    self.board = Board.new
    self.game_finished = false
    self.turn = 1
    self.replay = true
    self.players = []
    @player_colors = %w[white black]
    @alt_colors = { 'white' => 'Red', 'black' => 'Green' }
  end

  def game_setup
    welcome_msg
    2.times { |n| create_player(n) }
    rules_msg
    # sleep 3
    start_game
  end

  def keep_playing?
    return replay
  end

  def game_over?
    return game_finished
  end

  def create_player(count)
    p_name = refine_name(count)
    # p_name = players.empty? ? 'joe' : 'beck'
    store_new_player(p_name)
  end

  def store_new_player(username)
    newcomer = Player.new(username)
    self.players.empty? ? newcomer.designate_color(player_colors.first) : newcomer.designate_color(player_colors.last)
    self.players.push(newcomer)
    player_created_msg(newcomer, alt_colors)
    # sleep 1
  end

  def start_game
    while keep_playing?
      play_once
      # sleep 2
      prompt_replay
      game_end
    end
  end

  def play_once
    until game_over?
      players.each do |player|
        other_player = player.piece_color.eql?('white') ? players.last : players.first
        break if game_draw_status(player)
        show_chess_board(self.board)
        moving_info_msg
        turn_msg(turn)
        move_piece(player, turn, board, other_player)
        break if check_game_status(player, other_player)
        # sleep 1
      end
      self.turn += 1
    end
  end

  def check_game_status(player, other_player)
    if checkmate?(board, player, other_player)
      winner_msg(player.name)
      show_chess_board(board)
      return self.game_finished = true
    elsif check?(board, player)
      chess_check_msg(player, other_player, alt_colors)
    end
  end

  def game_draw_status(player)
    if stalemate?(board, player) || dead_position?(board)
      stalemate_msg
      show_chess_board(board)
      return self.game_finished = true
    end
  end

  def prompt_replay
    replay_choice = user_decision
    self.replay = false if replay_choice.eql?('n')
  end

  def game_end
    keep_playing? ? game_reset : goodbye_msg
  end

  def game_reset
    self.game_finished = false
    self.turn = 1
    players.each { |player| player.reset_captured }
    self.board.occupy_board
  end
end
