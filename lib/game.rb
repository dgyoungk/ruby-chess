require 'pry-byebug'

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
    2.times { |n| create_player(n) }
    rules_msg
    sleep(5)
    info_msg
    sleep(8)
    start_game
  end

  def keep_playing?
    return replay
  end

  def game_over?
    return game_finished
  end

  def create_player(count)
    new_player_msg(count)
    p_name = gets.chomp
    assign_player(p_name)
  end

  def assign_player(username)
    return unless player1.nil? || player2.nil?
    if player1.nil?
      self.player1 = Player.new(username)
      player1.designate_color(player_colors.first)
      players.push(player1)
      player_created_msg(player1)
    else
      self.player2 = Player.new(username)
      player2.designate_color(player_colors.last)
      players.push(player2)
      player_created_msg(player2)
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
    until game_over?
      players.each do |player|
        show_chess_board(board)
        moving_info_msg
        turn_msg(turn)
        move_piece(player)
        binding.pry
        break if check_game_status(player)
      end
      self.turn += 1
    end
  end

  def move_piece(player)
    player_pieces = board.squares.values.select { |spot| spot.occupied_by.color.eql?(player.piece_color) }
    move_notation = piece_position(player).split(/,\s*/)
    move_notation = square_occupancy(move_notation, player)
    move_notation, temp_piece = filter_move(move_notation, player_pieces, player)
    move_or_capture(player, move_notation, temp_piece)
  end

  def filter_move(move_notation, player_pieces, player)
    move_notation, temp_piece = correct_piece(player_pieces, move_notation, player)
    until legal_move?(move_notation, temp_piece)
      illegal_move_msg
      move_notation = piece_position(player).split(/,\s*/)
      temp_piece = correct_piece(player_pieces, move_notation, player)
    end
    return move_notation, temp_piece
  end

  def square_occupancy(move_notation, player)
    destination = piece_destination(move_notation)
    while board.squares[destination].occupied_by.color.eql?(player.piece_color)
      square_occupied_msg
      move_notation = piece_position(player).split(/,\s*/)
      destination = piece_destination(move_notation)
    end
    move_notation
  end

  def move_or_capture(player, move_notation, temp_piece)
    destination = piece_destination(move_notation)
    if empty_spot?(destination, board)
      piece_moving(move_notation, player, temp_piece)
    elsif !board.squares[destination].occupied_by.color.eql?(player.piece_color)
      piece_capturing(move_notation, player, temp_piece)
    end
  end

  def piece_moving(move_notation, player, temp_piece)
    case temp_piece.occupied_by.type
    when 'knight'
      swap_places(move_notation, temp_piece)
    when 'king'
      move_king_piece(move_notation, player, temp_piece)
    when 'pawn'
      move_pawn_piece(move_notation, player, temp_piece)
    else
      move_other_piece(move_notation, player, temp_piece)
    end
  end

  def move_king_piece(move_notation, player, temp_piece)
    destination = piece_destination(move_notation)
    swap_places(move_notation, temp_piece)
    while check?(board, player)
      check_move_msg
      temp_piece.add_occupancy(board.squares[destination].occupied_by)
      add_blank_spot(board.squares[destination])
      move_notation = piece_position(player).split(/,\s*/)
      swap_places(move_notation, temp_piece)
    end
  end

  def move_pawn_piece(move_notation, player, temp_piece)
    # for pawns, it can only move 2 squares only if it hasn't moved from the initial spot yet
    # so I have to check whether the piece's current coords are either 2 or 7, depending on the piece color
    starting_pos = player.piece_color.eql?('white') ? 7 : 2
    non_capture_moves = pawn_allowed_moves(starting_pos, temp_piece)
    move_notation = legal_pawn_not(move_notation, non_capture_moves, player, temp_piece)
    swap_places(move_notation, temp_piece)
  end

  def move_other_piece(move_notation, player, temp_piece)
    until clear_path?(move_notation, player, board)
      blocked_path_msg
      move_notation = piece_position(player).split(/,\s*/)
    end
    destination = piece_destination(move_notation)
    swap_places(move_notation, temp_piece)
  end

  def piece_capturing(move_notation, player, temp_piece)
    case temp_piece.occupied_by.type
    when 'knight', 'king'
      capture_piece(move_notation, player, temp_piece)
    when 'pawn'
      pawn_capture(move_notation, player, temp_piece)
    else
      non_knight_capture(move_notation, player, temp_piece)
    end
  end

  def non_knight_capture(move_notation, player, spot)
    until clear_path?(move_notation, player, board)
      blocked_path_msg
      move_notation = piece_position(player).split(/,\s*/)
    end
    capture_piece(move_notation, player, spot)
  end

  # for pawns capturing, I have to check moves that only go in a digonal direction
  # i.e. all moves that don't contain 0 or 2
  def pawn_capture(move_notation, player, temp_piece)
    capturing_moves = color_specific_captures(temp_piece)
    move_notation = legal_pawn_not(move_notation, capturing_moves, player, temp_piece)
    capture_piece(move_notation, player, temp_piece)
  end

  def swap_places(move_notation, spot)
    destination = piece_destination(move_notation)
    board.squares[destination].add_occupancy(spot.occupied_by)
    add_blank_spot(spot)
  end

  def capture_piece(move_notation, player, spot)
    destination = piece_destination(move_notation)
    captured = board.squares[destination].occupied_by
    player.update_captured(captured)
    swap_places(move_notation, spot)
  end

  def check_game_status(player)
    if checkmate?(board, player, players)
      self.game_finished = true
      winner_msg(player.name)
      return true
    elsif check?(board, player)
      chess_check_msg(player)
    elsif stalemate?(board, player) || dead_position?(board)
      self.game_finished = true
      no_winner_msg
      return true
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
    players.each { |player| player.reset_captured }
    self.board.occupy_board
  end
end
