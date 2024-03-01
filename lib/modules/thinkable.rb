# './lib/modules/thinkable.rb'
module Thinkable
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

  def decision_verified?(p_choice)
    %w[y n].include?(p_choice)
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

  def format_verified?(user_notation, status = [])
    # things to check:
    # first one should be a letter included in the initials hash
    # total length excluding punctuation and whitespace should be 4
    # all numbers should be inside the chess board i.e. less than 8
    pure_info = user_notation.split(/,\s*/).join('')
    pure_info.size.eql?(4) ? status.push(true) : status.push(false)
    piece_initials.keys.include?(pure_info.chars.first) ? status.push(true)  : status.push(false)
    pure_info.slice(1..).chars.all? { |info| info.to_i <= 8 } ? status.push(true) : status.push(false)
    return status.all?(true)
  end

  def piece_matched?(move_notation, spot)
    return column_match?(spot.coords, move_notation) && type_match?(spot, move_notation)
  end

  def column_match?(coords, move_notation)
    return (coords.last).eql?(piece_column(move_notation))
  end

  def type_match?(spot, move_notation)
    return spot.occupied_by.type.eql?(piece_type(move_notation))
  end

  # methods that help chess pieces make a legal move i.e. checking moving path
  def empty_spot?(coords, board)
    return board.squares[coords].occupied_by.instance_of? ChessPiece
  end

  # checking whether the move is possible...
  # get the move by subtracting the current coords from the destination coords
  # return whether the piece's possible_moves includes the resulting coords
  def legal_move?(move_notation, spot)
    temp_dest = piece_destination(move_notation)
    move_to_make = [temp_dest.first - spot.coords.first, temp_dest.last - spot.coords.last]
    return spot.occupied_by.possible_moves.include?(move_to_make)
  end

  def clear_path?(move_notation, player, board)
    destination = piece_destination(move_notation)
    player_pieces = board.squares.values.select { |spot| spot.occupied_by.color.eql?(player.piece_color) }
    player_pieces.each do |spot|
      if piece_matched?(move_notation, player, spot)
        return check_path(destination, spot, board)
      end
    end
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

  def create_count(difference, count = [])
    if difference.first.zero?
      count = [0, difference.last.negative? ? -1 : 1]
    elsif difference.last.zero?
      count = [difference.first.negative? ? -1 : 1, 0]
    else
      count.push(difference.first.negative? ? -1 : 1)
      count.push(difference.last.negative? ? -1 : 1)
    end
    count
  end

  def check_empty_spots(difference, count, board, starting, results = [])
    temp_dest = [starting.first + count.first, starting.last + count.last]
    if count.eql?(difference) && empty_spot?(temp_dest, board)
      results.push(true)
      return results
    end
    until count.eql?(difference)
      results.push(empty_spot?(temp_dest, board))
      count = update_count(count)
    end
    results
  end

  def update_count(count)
    if count.first.zero?
      count[-1] = count.last.negative? ? count.last - 1 : count.last + 1
    elsif count.last.zero?
      count[0] = count.first.negative? ? count.first - 1 : count.first + 1
    else
      count = [count.first.negative? ? count.first - 1 : count.first + 1, count.last.negative? ? count.last - 1 : count.last + 1]
    end
    count
  end

  # game draw condition checking
  def dead_position?(board)
    return board.squares.values.select { |spot| spot.occupied_by.instance_of? ChessPiece }.size.eql?(62)
  end

  def stalemate?(board, player)
    not_checking = %w(king pawn)
    opp = opponent_pieces(board, player, not_checking)
    king_piece = player_king_piece(board, player)
    status = king_overlapping(board, king_piece, opp)
    return status.all?(true)
  end

  def king_overlapping(board, king_piece, opp)
    stales = []
    valid_moves(board, king_piece).each_with_index do |king_pair, idx|
      king_temp_dest = [king_piece.coords.first + king_pair.first, king_piece.coords.last + king_pair.last]
      stales.push(overlapping_pieces(king_temp_dest, opp[idx], board))
    end
    stales
  end

  def overlapping_pieces(king_temp_dest, opp_piece, board)
    opp_moves = valid_moves(board, opp_piece)
    return false if opp_moves.empty?
    results = opp_moves.each_with_object([]) do |opp_pair, arr|
      opp_temp_dest = [opp_piece.coords.first + opp_pair.first, opp_piece.coords.last + opp_pair.last]
      king_temp_dest.eql?(opp_temp_dest) ? arr.push(true) : next
    end
    results.any?(true)
  end

  def checkmate?(board, player)
    return check?(board, player) && stalemate?(board, player)
  end

  def check?(board, player, results = [])
    # I need to get every single ranked piece e.g. Rook, Knight, Bishop, Queen
    # and check if a King piece is in their path AND a piece is not blocking the way
    # only exception is the knight, I just need to check if a king is one move away
    # so 2 methods, one for the knight piece and another for the non-knight pieces
    checking_pieces = piece_initials.values.reject { |type| type.eql?('king')  }
    # each element in types will be an array of nodes that contain pieces
    checking_pieces.each do |type|
      pieces = pieces_on_board(board, player, type)
      results = pieces.each_with_object([]) { |spot, arr| arr.push(piece_check(board, spot)) }
    end
    return results.any?(true)
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
    results = valid_moves(board, piece).each_with_object([]) do |pair, arr|
      temp_dest = [piece.coords.first + pair.first, piece.coords.last + pair.last]
      temp_piece = board.squares[temp_dest].occupied_by
      arr.push(true) if temp_piece.type.eql?('king') && !temp_piece.color.eql?(piece.occupied_by.color)
      arr
    end
    return results.any?(true)
  end

  def pawn_check(board, piece)
    capturing_move = piece.occupied_by.possible_moves.reject { |pair| pair.include?(0) }
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
      arr.push(true) if temp_piece.type.eql?('king') && !temp_piece.color.eql?(piece.occupied_by.color)
      arr
    end
    return results.any?(true)
  end

  def valid_moves(board, spot)
    # I want to select a piece's moves that are legal(stays on the board) and will not collide with other pieces(blank spot)
    valids = spot.occupied_by.possible_moves.select do |pair|
      temp_move = [spot.coords.first + pair.first, spot.coords.last + pair.last]
      next if board.squares[temp_move].nil?
      check_path(temp_move, spot, board, pair)
    end
  end
end
