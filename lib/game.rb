require_relative 'board'
require_relative 'player'
require './lib/modules/chess_logic.rb'

Dir["./lib/modules/*.rb"].each {|file| require file }

# './lib/game.rb'
class Game
  include ChessLogic

  attr_accessor :player1, :player2, :board, :game_finished, :turn, :replay, :players

  attr_reader :player_colors

  def initialize
    self.player1 = nil
    self.player2 = nil
    self.board = Board.new
    self.game_finished = false
    self.turn = 1
    self.replay = true
    self.players = []
    @player_colors = %w[white black]
  end

  def game_setup
    welcome_msg
    2.times { create_player }
    rules_msg
    info_msg
    moving_info_msg
    start_game
  end

  def keep_playing?
    return replay
  end

  def create_player
    new_player_msg
    p_name = gets.chomp
    assign_player(p_name)
  end

  def assign_player(username)
    return unless player1.nil? || player2.nil?
    if player1.nil?
      self.player1 = Player.new(username)
      player1.designate_color(player_colors.first)
      players.push(player1)
    else
      self.player2 = Player.new(username)
      plaeyr2.designate_color(player_colors.last)
      players.push(player1)
    end
  end

  def start_game
    while keep_playing?
      play_once
      prompt_replay
      game_end
    end
  end

  def play_once
    until game_finished
      show_chess_board(board)
      turn_msg(turn)
      players.each do |player|
        move_piece(player)
        check_game_status(player)
      end
    end
  end

  def move_piece(player)
    move_notation = piece_position(player).split(/,\s*/)
    until clear_path?(move_notation, player, board) || piece_type(move_notation).eql?('knight')
      error_msg
      move_notation = piece_position(player).split(/,\s*/)
    end
    update_piece_position(move_notation, player)
  end

  def update_piece_position(move_notation, player)
    board.squares.each do |coords, spot|
      if piece_matched?(move_notation, player, coords, spot)
        empty_spot?(piece_destination(move_notation), board) ? swap_places(move_notation, spot) : capture_piece(move_notation, player, spot)
        # capture_piece(move_notation, player, spot) unless empty_spot?(move_notation)
        # swap_places(move_notation, spot) if empty_spot?(move_notation)
      end
    end
  end

  def swap_places(move_notation, spot)
    board.squares[piece_destination(move_notation)].add_occupancy(spot.occupied_by)
    add_blank_spot(spot)
  end

  def capture_piece(move_notation, player, spot)
    captured = board.squares[piece_destination(move_notation)].occupied_by
    player.update_captured(captured)
    swap_places(move_notation, spot)
  end

  def check_game_status(player)
    if checkmate?(player)
      game_finished = true
      winner_msg
    elsif stalemate(board, player) || dead_position?(board)
      game_finished = true
      no_winner_msg
    elsif check?(board, player)
      chess_check_msg
    end
  end

  def prompt_replay
    replay_choice = user_decision
    self.replay = false if replay_choice == 'n'
  end

  def game_end
    keep_playing? ? game_reset : goodbye_msg
  end

  def game_reset
    self.game_finished = false
    self.turn = 1
  end
end

# TODO: implement game winning logic and refine game-resetting logic
