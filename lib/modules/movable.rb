# frozen_string_literal: false

# './lib/modules/movable.rb'
module Movable
  def moves_of_knight
    base = (-2..2).to_a.repeated_permutation(2).to_a
    base.reject { |pair| pair.first.eql?(pair.last) || pair.include?(0) || pair.first.eql?(-pair.last) }
  end

  def moves_of_pawn
    [[1, 0], [2, 0], [-1, 0], [-2, 0], [-1, 1], [1, 1], [1, -1], [-1, -1]]
  end

  def moves_of_rook
    (-7..7).to_a.repeated_permutation(2).to_a.select do |pair|
      pair.first.zero? || pair.last.zero? unless pair.first.eql?(pair.last)
    end
  end

  def moves_of_bishop
    (-7..7).to_a.repeated_permutation(2).to_a.select do |pair|
      pair.first.eql?(pair.last) || pair.first.eql?(-pair.last) unless pair.first.zero?
    end
  end

  def color_specific_captures(piece)
    case piece.occupied_by.color
    when 'white'
      piece.occupied_by.possible_moves.select { |pair| pair.eql?([-1, 1]) || pair.eql?([-1, -1]) }
    when 'black'
      piece.occupied_by.possible_moves.select { |pair| pair.eql?([1, 1]) || pair.eql?([1, -1]) }
    end
  end

  def pawn_allowed_moves(starting_pos, temp_piece)
    # if the piece is at the starting position, they can move 2 or 1 spaces
    return pawn_starting_moves(temp_piece) if temp_piece.coords.first.eql?(starting_pos)

    # if not, the piece can only move 1 space
    pawn_regular_moves(temp_piece)
  end

  def pawn_regular_moves(temp_piece)
    # if the pawn is white, they can only move upwards
    if temp_piece.occupied_by.color.eql?('white')
      return temp_piece.occupied_by.possible_moves.select { |pair| pair.eql?([-1, 0]) }
    end

    # if the pawn is black, they can only move downwards

    temp_piece.occupied_by.possible_moves.select { |pair| pair.eql?([1, 0]) }
  end

  def pawn_starting_moves(temp_piece)
    # if the pawn is white, they can only move upwards
    if temp_piece.occupied_by.color.eql?('white')
      return temp_piece.occupied_by.possible_moves.select { |pair| pair.eql?([-2, 0]) || pair.eql?([-1, 0]) }
    end

    # if the pawn is black, they can only move downwards

    temp_piece.occupied_by.possible_moves.select { |pair| pair.eql?([2, 0]) || pair.eql?([1, 0]) }
  end

  def valid_moves(board, spot)
    within_bounds = spot.occupied_by.possible_moves.reject do |pair|
      board.squares[create_destination(spot.coords, pair)].nil?
    end
    within_bounds.select do |pair|
      temp_dest = create_destination(spot.coords, pair)
      if (caller[2][/`.*'/][1..-2]).include?('move')
        check_capture_path(temp_dest, spot, board, pair)
      else
        check_path(temp_dest, spot, board, pair)
      end
    end
  end

  def valid_captures(board, spot)
    spot.occupied_by.possible_moves.select do |pair|
      temp_dest = create_destination(spot.coords, pair)
      next if board.squares[temp_dest].nil?

      check_capture_path(temp_dest, spot, board, pair)
    end
  end
end
