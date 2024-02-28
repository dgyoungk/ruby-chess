# './lib/modules/thinkable.rb'
module Thinkable
  # this method will change the background colors
  def bg_colorize(string, rgb_values)
    "\e[48;2;#{rgb_values}m#{string}\e[0m"
  end

  def fg_colorize(string, rgb_values)
    %(\e[38;2;#{rgb_values}m#{string}\u0020\e[0m)
  end

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

  def format_verified?(user_notation)
    # things to check:
    # first one should be a letter included in the initials hash
    # total length excluding punctuation and whitespace should be 4
    # all numbers should be inside the chess board i.e. less than 8
    pure_info = user_notation.split(/,\s*/).join('')
    return true if pure_info.size.eql?(4)
    return true if piece_initials.keys.include?(pure_info.chars.first)
    return pure_info.slice(1..).chars.all? { |info| info < '8' }
  end

  def piece_matched?(move_notation, player, spot)
    return column_match?(spot.coords, move_notation) && type_match?(spot, move_notation) && color_match?(spot, player)
  end

  def column_match?(coords, move_notation)
    return (coords.last).eql?(piece_column(move_notation))
  end

  def type_match?(spot, move_notation)
    return spot.occupied_by.type == piece_type(move_notation)
  end

  def color_match?(spot, player)
    return spot.occupied_by.color == player.piece_color
  end

  # methods that help chess pieces make a legal move i.e. checking moving path
  def empty_spot?(coords, board)
    return board.squares[coords].occupied_by.instance_of? ChessPiece
  end

  def clear_path?(move_notation, player, board)
    destination = piece_destination(move_notation)
    board.squares.values.each do |spot|
      if piece_matched?(move_notation, player, spot)
        return check_path(destination, spot.coords, board)
      end
    end
  end

  def check_path(destination, starting, board, difference = [], count = [])
    if difference.empty?
      difference.push(destination.first - starting.first)
      difference.push(destination.last - starting.last)
    end
    difference.first.zero? ? count.push(0) : difference.first.negative? ? count.push(-1) : count.push(1)
    difference.last.zero? ? count.push(0) : difference.last.negative? ? count.push(-1) : count.push(1)
    path_results = check_empty_spots(difference, count, board, starting)
    path_results.empty? ? false : path_results.all?(true)
  end

  def check_empty_spots(difference, count, board, starting, results = [])
    until count.eql?(difference)
      results.push(empty_spot?([starting.first + count.first, starting.last + count.last], board))
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
      count.clear
      count.push(count.first.negative? ? count.first - 1 : count.first + 1)
      count.push(count.last.negative? ? count.last - 1 : count.last + 1)
      # count = [count.first.negative? ? count.first - 1 : count.first + 1, count.last.negative? ? count.last - 1 : count.last + 1]
    end
    count
  end

  # game draw condition checking
  def dead_position?(board)
    return board.squares.values.filter { |spot| spot.occupied_by.instance_of? ChessPiece }.size.eql?(62)
  end

  def stalemate?(board, player)
    not_checking = %w(king pawn)
    opp = opponent_pieces(board, player, not_checking)
    king_piece = player_king_piece(board, player)
    return false if king_moves.empty?
    king_overlapping(board, king_piece, opp).all?(true)
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

  def check?(board, player)
    # I need to get every single ranked piece e.g. Rook, Knight, Bishop, Queen
    # and check if a King piece is in their path AND a piece is not blocking the way
    # only exception is the knight, I just need to check if a king is one move away
    # so 2 methods, one for the knight piece and another for the non-knight pieces
    pieces_to_check = piece_initials.values.reject { |type| type.eql?('king')  }
    # each element in types will be an array of nodes that contain pieces
    types = pieces_to_check.each_with_object({}) { |type, hash| hash[type] = pieces_on_board(board, player, type) }
    results = types.each_with_object([]) do |(key, pieces), arr|
      arr.push(piece_check(board, key, pieces))
      arr
    end
    return results.any?(true)
  end

  def piece_check(board, key, pieces)
    # let's have this as the general check method and delegate to knight/non-knight pieces here
    # the concern is returning the results
    if key.eql?('knight')
      status = pieces.each_with_object([]) { |piece, arr| arr.push(knight_check(board, piece)) }
    elsif key.eql?('pawn')
      status = pieces.each_with_object([]) { |piece, arr| arr.push(pawn_check(board, piece)) }
    else
      status = pieces.each_with_object([]) { |piece, arr| arr.push(non_knight_check(board, piece)) }
    end
    return status.any?(true)
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
      next if board[temp_dest].nil?
      temp_piece = board[temp_dest].occupied_by
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
      check_path(temp_move, spot.coords, board, pair)
    end
  end
end
