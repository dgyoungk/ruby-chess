# './lib/modules/movable.rb'
module Movable
  def moves_of_knight
    base =  (-2..2).to_a.repeated_permutation(2).to_a
    return base.reject { |pair| pair.first.eql?(pair.last) || pair.include?(0) || pair.first.eql?(-(pair.last)) }
  end

  def moves_of_pawn
    return [[1, 0], [2, 0], [-1, 0], [-2, 0], [-1, 1], [1, 1], [1, -1], [-1, -1]]
  end

  def moves_of_rook
    base = (-7..7).to_a.repeated_permutation(2).to_a.select do |pair|
      unless pair.first.eql?(pair.last)
        pair.first.zero? || pair.last.zero?
      end
    end
  end

  def moves_of_bishop
    base = (-7..7).to_a.repeated_permutation(2).to_a.select do |pair|
      unless pair.first.zero?
        pair.first.eql?(pair.last) || pair.first.eql?(-pair.last)
      end
    end
  end

  def color_specific_captures(piece)
    case piece.occupied_by.color
    when 'white'
      return piece.occupied_by.possible_moves.select { |pair| pair.eql?([-1, 1]) || pair.eql?([-1, -1]) }
    when 'black'
      return piece.occupied_by.possible_moves.select { |pair| pair.eql?([1, 1]) || pair.eql?([1, -1]) }
    end
  end

  def pawn_allowed_moves(starting_pos, temp_piece)
    # if the piece is at the starting position, they can move 2 or 1 spaces
    if temp_piece.coords.first.eql?(starting_pos)
      pawn_starting_moves(starting_pos, temp_piece)
    else
      # if not, the piece can only move 1 space
      pawn_regular_moves(starting_pos, temp_piece)
    end
  end

  def pawn_regular_moves(starting_pos, temp_piece)
    # if the pawn is white, they can only move upwards
    if starting_pos.eql?(7)
      return temp_piece.occupied_by.possible_moves.select { |pair| pair.eql?([-1, 0]) }
    # if the pawn is black, they can only move downwards
    else
      return temp_piece.occupied_by.possible_moves.select { |pair| pair.eql?([1, 0]) }
    end
  end

  def pawn_starting_moves(starting_pos, temp_piece)
    # if the pawn is white, they can only move upwards
    if starting_pos.eql?(7)
      return temp_piece.occupied_by.possible_moves.select { |pair| pair.eql?([-2, 0]) || pair.eql?([-1, 0]) }
    # if the pawn is black, they can only move downwards
    else
      return temp_piece.occupied_by.possible_moves.select { |pair| pair.eql?([2, 0]) || pair.eql?([1, 0]) }
    end
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