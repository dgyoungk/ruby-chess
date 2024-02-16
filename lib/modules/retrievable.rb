# './lib/modules/retrievable.rb'
module Retrievable
  # the reject block removes the [0,0] move since it's redundant
  def board_edges
    return (-1..1).to_a.repeated_permutation(2).to_a.reject { |move| move.all? { |coord| coord.zero?} }
  end

  def board_coordinates
    return (0..7).to_a.repeated_permutation(2).to_a
  end

  def moves_of_knight
    base =  (-2..2).to_a.repeated_permutation(2).to_a
    return base.reject { |pair| pair.first.eql?(pair.last) || pair.include?(0) || pair.first.eql?(-(pair.last)) }
  end

  def moves_of_pawn
    return [[0, 1], [-1, 1], [1, 1], [0, 2]]
  end

  def moves_of_rook
    base = (-6..6).to_a.repeated_permutation(2).to_a.select do |pair|
      unless pair.first.eql?(pair.last)
        pair.first.zero? || pair.last.zero?
      end
    end
  end

  def moves_of_bishop
    base = (-6..6).to_a.repeated_permutation(2).to_a.select do |pair|
      unless pair.first.zero?
        pair.first.eql?(pair.last) || pair.first.eql?(-pair.last)
      end
    end
  end

  # method that houses all the unicode representation of the chess pieces
  def black_chess_pieces
    black_visuals = {
      'kingblack' => "\u0020\u2654\u0020",
      'queenblack' => "\u0020\u2655\u0020",
      'rookblack' => "\u0020\u2656\u0020",
      'bishopblack' => "\u0020\u2657\u0020",
      'knightblack' => "\u0020\u2658\u0020",
      'pawnblack' => "\u0020\u2659\u0020",
    }
  end

  def white_chess_pieces
    white_visuals = {
      'kingwhite' => "\u0020\u265A\u0020",
      'queenwhite' => "\u0020\u265B\u0020",
      'rookwhite' => "\u0020\u265C\u0020",
      'bishopwhite' => "\u0020\u265D\u0020",
      'knightwhite' => "\u0020\u265E\u0020",
      'pawnwhite' => "\u0020\u265F\u0020"
    }
  end

  def chess_board_colors
    square_colors = {
      white: '255;255;255',
      black: '0;0;0'
    }
  end

  def empty_square
    return "\u0020\u0020\u0020"
  end
end
