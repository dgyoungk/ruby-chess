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

  def piece_matched?(move_notation, player, coords, spot)
    return column_match?(coords, move_notation) && type_match?(spot, move_notation) && color_match?(spot, player)
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
    board.squares.each do |coords, spot|
      if piece_matched?(move_notation, player, coords, spot)
        return check_path(destination, coords, board)
      end
    end
  end

  def check_path(destination, starting, board, difference = [], count = [])
    difference.push(destination.first - starting.first)
    difference.push(destination.last - starting.last)
    difference.first.zero? ? count.push(0) : coords.first.negative? ? count.push(-1) : count.push(1)
    difference.last.zero? ? count.push(0) : coords.last.negative? ? count.push(-1) : count.push(1)
    return check_empty_spots(difference, count).all?(true)
  end

  def check_empty_spots(difference, count, board, results = [])
    until count.eql?(difference)
      if count.first.zero?
        count = [count.first, count.last.negative? ? count.last - 1 : count.last + 1]
      else
        count = [count.first.negative? ? count.first - 1 : count.first + 1, count.last.negative? ? count.last - 1 : count.last + 1]
      end
      results.push(empty_spot?(count, board))
    end
    results
  end

  # game draw condition checking
  def dead_position?(board)
    return board.squares.filter { |coords, spot| spot.occupied_by.instance_of? ChessPiece }.size.eql?(62)
  end

  def stalemate?(board)

  end

  def checkmate?(player1, player2)

  end

  # def check?(board)
  #   # I need to get every single ranked piece e.g. Rook, Knight, Bishop, Queen
  #   # and check if a King piece is in their path AND a piece is not blocking the way
  #   # only exception is the knight, I just need to check if a king is one move away
  #   rooks = pieces_on_board(board, 'rook')
  #   bishops = pieces_on_board(board, 'bishop')
  #   knights = pieces_on_board(board, 'knight')
  #   queens = pieces_on_board(board, 'queen')
  #   return rook_check?(board, rooks) || bishop_check?() || knight_check? || queen_check?
  # end
end
