# frozen_string_literal: false

require_relative 'board'
require_relative 'player'
require './lib/modules/chess_logic'
require './lib/game_pieces/queen'

# './lib/game.rb'
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
    sleep 3
    start_game
  end

  def keep_playing?
    replay
  end

  def game_over?
    game_finished
  end

  def create_player(count)
    p_name = refine_name(count)
    store_new_player(p_name, count)
  end

  def store_new_player(username, count)
    newcomer = Player.new(username)
    newcomer.designate_color(player_colors[count])
    players.push(newcomer)
    player_created_msg(newcomer, alt_colors)
    sleep 1
  end

  def start_game
    while keep_playing?
      play_once
      sleep 2
      prompt_replay
      game_end
    end
  end

  def play_once
    until game_over?
      players.each do |player|
        other_player = player.piece_color.eql?('white') ? players.last : players.first
        break if game_draw_status(player)

        show_chess_board(board)
        moving_info_msg
        turn_msg(turn)
        move_piece(player, board, other_player)
        break if check_game_status(player, other_player)
      end
      self.turn += 1
    end
  end

  def check_game_status(player, other_player)
    if checkmate?(board, player, other_player)
      winner_msg(player.name)
      show_chess_board(board)
      self.game_finished = true
    elsif check?(board, player)
      chess_check_msg(player, other_player, alt_colors)
      sleep 1
    end
  end

  def game_draw_status(player)
    return unless stalemate?(board, player) || dead_position?(board)

    stalemate_msg
    show_chess_board(board)
    self.game_finished = true
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
    players.each(&:reset_captured)
    board.occupy_board
  end
end
