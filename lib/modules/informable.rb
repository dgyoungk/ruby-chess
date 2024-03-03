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
    # let's say the current coords is 7, 2 and destination is 6, 2
    if difference.empty?
      difference.push(destination.first - spot.coords.first)
      difference.push(destination.last - spot.coords.last)
    end
    count = create_count(difference)
    path_results = check_empty_spots(difference, count, board, spot.coords)
    path_results.empty? ? false : path_results.all?(true)
  end

  def check_empty_spots(difference, count, board, starting, results = [])
    temp_dest = [starting.first + count.first, starting.last + count.last]
    return results.push(true) if count.eql?(difference)
    until count.eql?(difference)
      results.push(empty_spot?(temp_dest, board))
      count = update_count(count)
    end
    results
  end

  def king_overlapping(board, k_piece, rival_pieces)
    stales = []
    king_moves = valid_moves(board, k_piece)
    return stales.push(false) if king_moves.empty?
    rival_pieces.each do |r_piece|
      rival_moves = rival_piece_moves(board, r_piece)
      next if rival_moves.empty?
      stales.push(piece_overlap(rival_moves, r_piece, k_piece, king_moves))
    end
    stales
  end

  def rival_piece_moves(board, r_piece)
    case r_piece.occupied_by.type
    when 'knight'
      return r_piece.occupied_by.possible_moves
    when 'pawn'
      return pawn_capturing_moves(r_piece)
    else
      return valid_moves(board, r_piece)
    end
  end

  def piece_overlap(rival_moves, r_piece, k_piece, king_moves)
    rival_moves.each do |r_pair|
      rival_dest = [r_piece.coords.first + r_pair.first, r_piece.coords.last + r_pair.last]
      king_moves.each do |king_pair|
        king_dest = [k_piece.coords.first + king_pair.first, k_piece.coords.last + king_pair.last]
        return true if king_dest.eql?(rival_dest)
      end
    end
    false
  end

  def piece_check(board, piece)
    # let's have this as the general check method and delegate to knight/non-knight pieces here
    # the concern is returning the results
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
        return arr.push(check_path(temp_dest, piece, board, pair))
      end
    end
    return results.any?(true)
  end

  def pawn_check(board, piece)
    capturing_move = pawn_capturing_moves(piece)
    capturing_move = color_specific_captures(capturing_move, piece)
    results = capturing_move.each_with_object([]) do |pair, arr|
      temp_dest = [piece.coords.first + pair.first, piece.coords.last + pair.last]
      next if board.squares[temp_dest].nil?
      temp_piece = board.squares[temp_dest].occupied_by
      temp_piece.type.eql?('king') && !temp_piece.color.eql?(piece.occupied_by.color) ? arr.push(true) : arr.push(false)
    end
    return results.any?(true)
  end

  def knight_check(board, piece)
    results = piece.occupied_by.possible_moves.each_with_object([]) do |pair, arr|
      temp_dest = [piece.coords.first + pair.first, piece.coords.last + pair.last]
      next if board.squares[temp_dest].nil?
      temp_piece = board.squares[temp_dest].occupied_by
      temp_piece.type.eql?('king') && !temp_piece.color.eql?(piece.occupied_by.color) ? arr.push(true) : arr.push(false)
    end
    return results.any?(true)
  end
end
