require 'duplicate'
require_relative 'thinkable'
# './lib/modules/informable.rb'
module Informable
  include Thinkable

  def user_decision
    replay_msg
    decision = gets.chomp.downcase
    until decision_verified?(decision)
      error_msg
      replay_msg
      decision = gets.chomp.downcase
    end
    decision
  end

  def piece_position(player)
    move_msg(player)
    move_to = gets.chomp
    until format_verified?(move_to)
      error_msg
      move_msg(player)
      move_to = gets.chomp
    end
    move_to
  end

  def correct_piece(player_pieces, move_notation, player)
    temp_piece = selected_piece(player_pieces, move_notation)
    until temp_piece.instance_of? Node
      incorrect_piece_msg
      move_notation = piece_position(player).split(/,\s*/)
      temp_piece = selected_piece(player_pieces, move_notation)
    end
    return move_notation, temp_piece
  end

  def check_path(destination, spot, board, difference = [])
    if difference.empty?
      difference.push(destination.first - spot.coords.first)
      difference.push(destination.last - spot.coords.last)
    end
    count = create_count(difference)
    path_results = check_empty_spots(difference, count, board, spot.coords)
    path_results.all?(true)
  end

  def check_empty_spots(difference, count, board, starting, results = [])
    temp_dest = [starting.first + count.first, starting.last + count.last]
    return results.push(empty_spot?(temp_dest, board)) if count.eql?(difference)
    until count.eql?(difference)
      results.push(empty_spot?(temp_dest, board))
      count = update_count(count)
    end
    results
  end

  def determine_moves(board, piece)
    case piece.occupied_by.type
    when 'knight'
      return piece.occupied_by.possible_moves
    when 'pawn'
      return color_specific_captures(piece)
    else
      return valid_moves(board, piece)
    end
  end

  def piece_check(board, piece)
    # let's have this as the general check method and delegate to knight/non-knight pieces here
    case piece.occupied_by.type
    when 'knight'
      return knight_check(board, piece)
    when 'pawn'
      return pawn_check(board, piece)
    else
      return non_knight_check(board, piece)
    end
  end

  def non_knight_check(board, piece)
    piece_moves = piece.occupied_by.possible_moves
    results = piece_moves.each_with_object([]) do |pair, arr|
      temp_dest = [piece.coords.first + pair.first, piece.coords.last + pair.last]
      next if board.squares[temp_dest].nil?
      temp_piece = board.squares[temp_dest].occupied_by
      if temp_piece.type.eql?('king') && !temp_piece.color.eql?(piece.occupied_by.color)
        arr.push(true) if pair.all? { |half| half.eql?(1) || half.eql?(-1) }
        arr.push(check_path(temp_dest, piece, board, pair))
      end
    end
    return results.any?(true)
  end

  def pawn_check(board, piece)
    capturing_move = color_specific_captures(piece)
    pawnee_results = check_for_check(board, piece, capturing_move)
    return pawnee_results.any?(true)
  end

  def knight_check(board, piece)
    thk = piece.occupied_by.possible_moves
    thk_results = check_for_check(board, piece, thk)
    return thk_results.any?(true)
  end

  def check_for_check(board, piece, moves)
    not_checkers = moves.each_with_object([]) do |pair, arr|
      temp_dest = [piece.coords.first + pair.first, piece.coords.last + pair.last]
      next if board.squares[temp_dest].nil?
      temp_piece = board.squares[temp_dest].occupied_by
      temp_piece.type.eql?('king') && !temp_piece.color.eql?(piece.occupied_by.color) ? arr.push(true) : arr.push(false)
    end
  end

  def check_for_stale(board, moves, piece, rival_pieces)
    temp_board = duplicate(board)
    stales = moves.each_with_object([]) do |pair, arr|
      temp_dest = [piece.coords.first + pair.first, piece.coords.last + pair.last]
      next if temp_board.squares[temp_dest].nil?
      temp_board.squares[temp_dest].occupied_by = piece.occupied_by
      move_results = rival_pieces.each_with_object([]) { |r_piece, r_arr| r_arr.push(piece_check(temp_board, r_piece)) }
      arr.push(move_results.any?(true))
    end
  end
end
